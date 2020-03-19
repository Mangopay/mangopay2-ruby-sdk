require 'net/http'
require 'cgi/util'
require 'digest/md5'
require 'multi_json'
require 'benchmark'
require 'logger'
require 'time'

# helpers
require 'mangopay/version'
require 'mangopay/errors'


module MangoPay

  autoload :HTTPCalls, 'mangopay/http_calls'
  autoload :Resource, 'mangopay/resource'
  autoload :Client, 'mangopay/client'
  autoload :User, 'mangopay/user'
  autoload :NaturalUser, 'mangopay/natural_user'
  autoload :LegalUser, 'mangopay/legal_user'
  autoload :PayIn, 'mangopay/pay_in'
  autoload :PayOut, 'mangopay/pay_out'
  autoload :Transfer, 'mangopay/transfer'
  autoload :Transaction, 'mangopay/transaction'
  autoload :Wallet, 'mangopay/wallet'
  autoload :BankAccount, 'mangopay/bank_account'
  autoload :CardRegistration, 'mangopay/card_registration'
  autoload :PreAuthorization, 'mangopay/pre_authorization'
  autoload :Card, 'mangopay/card'
  autoload :Event, 'mangopay/event'
  autoload :KycDocument, 'mangopay/kyc_document'
  autoload :Hook, 'mangopay/hook'
  autoload :Refund, 'mangopay/refund'
  autoload :Dispute, 'mangopay/dispute'
  autoload :Mandate, 'mangopay/mandate'
  autoload :Report, 'mangopay/report'
  autoload :JSON, 'mangopay/json'
  autoload :AuthorizationToken, 'mangopay/authorization_token'
  autoload :FilterParameters, 'mangopay/filter_parameters'
  autoload :BankingAliases, 'mangopay/bankingaliases'
  autoload :BankingAliasesIBAN, 'mangopay/bankingaliases_iban'
  autoload :UboDeclaration, 'mangopay/ubo_declaration'
  autoload :Ubo, 'mangopay/ubo'

  # temporary
  autoload :Temp, 'mangopay/temp'

  class Configuration
    attr_accessor :preproduction, :root_url,
                  :client_id, :client_apiKey,
                  :temp_dir, :log_file, :http_timeout,
                  :logger

    def preproduction
      @preproduction || false
    end

    def root_url
      @root_url || (@preproduction == true ? "https://api.sandbox.mangopay.com" : "https://api.mangopay.com")
    end

    def http_timeout
      @http_timeout || 10000
    end
  end

  class << self
    def version_code
      "v2.01"
    end

    def api_path
      "/#{version_code}/#{MangoPay.configuration.client_id}"
    end

    def api_uri(url='')
      URI(configuration.root_url + url)
    end

    def configuration=(value)
      Thread.current[:mangopay_configuration] = value
      @last_configuration_set = value
    end

    def configuration
      config = Thread.current[:mangopay_configuration]

      config                                                ||
      ( @last_configuration_set &&
        (self.configuration = @last_configuration_set.dup)) ||
      (self.configuration = MangoPay::Configuration.new)
    end

    def configure
      config = self.configuration
      yield config
      self.configuration = config
    end

    def with_configuration(config)
      original_config = MangoPay.configuration
      MangoPay.configuration = config
      yield
    ensure
      MangoPay.configuration = original_config
    end

    def ratelimit
      @ratelimit
    end

    def ratelimit=(obj)
      @ratelimit = obj
    end

    #
    # - +method+: HTTP method; lowercase symbol, e.g. :get, :post etc.
    # - +url+: the part after Configuration#root_url
    # - +params+: hash; entity data for creation, update etc.; will dump it by JSON and assign to Net::HTTPRequest#body
    # - +filters+: hash; pagination params etc.; will encode it by URI and assign to URI#query
    # - +headers_or_idempotency_key+: hash of headers; or replaced by request_headers if nil; or added to request_headers as idempotency key otherwise (see https://docs.mangopay.com/api-references/idempotency-support/)
    # - +before_request_proc+: optional proc; will call it passing the Net::HTTPRequest instance just before Net::HTTPRequest#request
    #
    # Raises MangoPay::ResponseError if response code != 200.
    #
    def request(method, url, params={}, filters={}, headers_or_idempotency_key = nil, before_request_proc = nil)
      uri = api_uri(url)
      uri.query = URI.encode_www_form(filters) unless filters.empty?

      if headers_or_idempotency_key.is_a?(Hash)
        headers = headers_or_idempotency_key
      else
        headers = request_headers
        headers['Idempotency-Key'] = headers_or_idempotency_key if headers_or_idempotency_key != nil
      end

      res = Net::HTTP.start(uri.host, uri.port, use_ssl: true, :read_timeout => configuration.http_timeout) do |http|
        req = Net::HTTP::const_get(method.capitalize).new(uri.request_uri, headers)
        req.body = JSON.dump(params)
        before_request_proc.call(req) if before_request_proc
        do_request(http, req, uri)
      end

      # decode json data
      data = res.body.to_s.empty? ? {} : JSON.load(res.body.to_s)

      unless res.is_a?(Net::HTTPOK)
        raise MangoPay::ResponseError.new(uri, res.code, data)
      end

      # copy pagination info if any
      ['x-number-of-pages', 'x-number-of-items'].each { |k|
        filters[k.gsub('x-number-of-', 'total_')] = res[k].to_i if res[k]
      }

      if res['x-ratelimit']
        self.ratelimit = {
          limit: res['x-ratelimit'].split(", "),
          remaining: res['x-ratelimit-remaining'].split(", "),
          reset: res['x-ratelimit-reset'].split(", ")
        }
      end

      data
    end

    # Retrieve a previous response by idempotency_key
    # See https://docs.mangopay.com/api-references/idempotency-support/
    def fetch_response(idempotency_key)
      url = "#{api_path}/responses/#{idempotency_key}"
      request(:get, url)
    end

    private

    def user_agent
      {
          bindings_version: VERSION,
          lang: 'ruby',
          lang_version: "#{RUBY_VERSION} p#{RUBY_PATCHLEVEL} (#{RUBY_RELEASE_DATE})",
          platform: RUBY_PLATFORM,
          uname: get_uname
      }
    end

    def get_uname
      `uname -a 2>/dev/null`.strip if RUBY_PLATFORM =~ /linux|darwin/i
    rescue Errno::ENOMEM
      'uname lookup failed'
    end

    def request_headers
      auth_token = AuthorizationToken::Manager.get_token
      headers = {
          'User-Agent' => "MANGOPAY V2 RubyBindings/#{VERSION}",
          'Authorization' => "#{auth_token['token_type']} #{auth_token['access_token']}",
          'Content-Type' => 'application/json'
      }
      begin
        headers.update('x_mangopay_client_user_agent' => JSON.dump(user_agent))
      rescue => e
        headers.update('x_mangopay_client_raw_user_agent' => user_agent.inspect, error: "#{e} (#{e.class})")
      end
    end

    def do_request(http, req, uri)
      if logs_required?
        do_request_with_log(http, req, uri)
      else
        do_request_without_log(http, req)
      end
    end

    def do_request_with_log(http, req, uri)
      res, time = nil, nil
      params = FilterParameters.request(req.body)
      line = "[#{Time.now.iso8601}] #{req.method.upcase} \"#{uri.to_s}\" #{params}"
      begin
        time = Benchmark.realtime { res = do_request_without_log(http, req) }
        res
      ensure
        params = FilterParameters.response(res.body)
        line = "#{log_severity(res)} #{line}"
        line += "\n  [#{(time * 1000).round(1)}ms] #{res.code} #{params}\n"
        logger.info { line }
      end
    end

    def do_request_without_log(http, req)
      http.request(req)
    end

    def log_severity(res)
      errors = [Net::HTTPClientError, Net::HTTPServerError, Net::HTTPUnknownResponse]
      errors.any? { |klass| res.is_a?(klass) } ? 'E' : 'I'
    end

    def logger
      raise NotImplementedError unless logs_required?
      return @logger if @logger

      if !configuration.logger.nil?
        @logger = configuration.logger
      elsif !configuration.log_file.nil?
        @logger = Logger.new(configuration.log_file)
        @logger.formatter = proc do |_, _, _, msg|
          "#{msg}\n"
        end
      end

      @logger
    end

    def logs_required?
      !configuration.log_file.nil? || !configuration.logger.nil?
    end
  end
end
