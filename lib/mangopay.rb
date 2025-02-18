require 'net/http'
require 'cgi/util'
require 'digest/md5'
require 'multi_json'
require 'benchmark'
require 'logger'
require 'time'
require 'securerandom'

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
  autoload :Regulatory, 'mangopay/regulatory'
  autoload :Deposit, 'mangopay/deposit'
  autoload :Conversion, 'mangopay/conversion'
  autoload :PaymentMethodMetadata, 'mangopay/payment_method_metadata'
  autoload :VirtualAccount, 'mangopay/virtual_account'
  autoload :IdentityVerification, 'mangopay/identity_verification'

  # temporary
  autoload :Temp, 'mangopay/temp'

  @configurations = {}

  class Configuration
    attr_accessor :preproduction, :root_url,
                  :client_id, :client_apiKey,
                  :temp_dir, :log_file, :log_trace_headers, :http_timeout,
                  :http_max_retries, :http_open_timeout,
                  :logger, :use_ssl, :uk_header_flag

    def apply_configuration
      MangoPay.configure do |config|
        config.preproduction = @preproduction
        config.client_id = @client_id
        config.client_apiKey = @client_apiKey
        config.log_file = @log_file
        config.log_trace_headers = @log_trace_headers
        config.http_timeout = @http_timeout
        config.http_max_retries = @http_max_retries
        config.http_open_timeout = @http_open_timeout
        config.use_ssl = @use_ssl
        config.logger = @logger
        config.uk_header_flag = @uk_header_flag
      end
    end

    def preproduction
      @preproduction || false
    end

    def root_url
      @root_url || (@preproduction == true ? "https://api.sandbox.mangopay.com" : "https://api.mangopay.com")
    end

    def http_timeout
      @http_timeout || 30
    end

    def http_max_retries
      @http_max_retries || 1
    end

    def http_open_timeout
      @http_open_timeout || 30
    end

    def use_ssl?
      return true unless preproduction == true
      return true unless defined?(@use_ssl)
      return false if @use_ssl == false

      true
    end
    
    def log_trace_headers
      @log_trace_headers || false
    end

    def uk_header_flag
      @uk_header_flag || false
    end
  end

  class << self
    def version_code
      "v2.01"
    end

    def api_path
      "/#{version_code}/#{MangoPay.configuration.client_id}"
    end

    def api_path_no_client
      "/#{version_code}"
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

    # Add MangoPay.Configuration to the list of configs
    def add_config(name, config)
      @configurations[name] = config
    end

    # Fetch a MangoPay configuration from the list of configs. Throw error if not found
    def get_config(name)
      config = @configurations[name]
      raise "Could not find any configuration with name '#{name}'" unless config
      config
    end

    def remove_config(name)
      raise "Could not find any configuration with name '#{name}'" unless @configurations[name]
      @configurations[name] = nil
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

      if configuration.uk_header_flag
        headers['x-tenant-id'] = 'uk'
      end

      res = Net::HTTP.start(uri.host, uri.port, :use_ssl => configuration.use_ssl?, :read_timeout => configuration.http_timeout,
                            :max_retries => configuration.http_max_retries,
                            :open_timeout => configuration.http_open_timeout, ssl_version: :TLSv1_2) do |http|
        req = Net::HTTP::const_get(method.capitalize).new(uri.request_uri, headers)
        req.body = JSON.dump(params)
        before_request_proc.call(req) if before_request_proc
        do_request(http, req, uri)
      end

      raise MangoPay::ResponseError.new(uri, '408', {'Message' => 'Request Timeout'}) if res.nil?

      # decode json data
      begin
        data = res.body.to_s.empty? ? {} : JSON.load(res.body.to_s)
      rescue MultiJson::ParseError
        details = {}
        details['Message'] = res.body
        raise MangoPay::ResponseError.new(uri, res.code, details)
      end

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
          'User-Agent' => "MangoPay V2 SDK Ruby Bindings #{VERSION}",
          'Authorization' => "#{auth_token['token_type']} #{auth_token['access_token']}",
          'Content-Type' => 'application/json'
      }
      if configuration.log_trace_headers
        headers.update('x_mangopay_trace-id' => SecureRandom.uuid)
      end
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
      if configuration.log_trace_headers
        trace_headers = JSON.dump({ 'Idempotency-Key' => req['Idempotency-Key'] , 'x_mangopay_trace-id' =>  req['x_mangopay_trace-id'] })
        line = "[#{Time.now.iso8601}] #{req.method.upcase} \"#{uri.to_s}\" #{params} #{trace_headers}"
      else
        line = "[#{Time.now.iso8601}] #{req.method.upcase} \"#{uri.to_s}\" #{params}"
      end
      begin
        time = Benchmark.realtime {
          begin
            res = do_request_without_log(http, req)
          rescue Net::ReadTimeout
            res = nil
          end
        }
        res
      ensure
        line = "#{log_severity(res)} #{line}"
        if time.nil?
          time_log = "[Unknown ms]"
        else
          time_log = "[#{(time * 1000).round(1)}ms]"
        end
        if res.nil?
          params = ''
          line += "\n  #{time_log} 408 Request Timeout #{params}\n"
        else
          params = FilterParameters.response(res.body)
          line += "\n  #{time_log} #{res.code} #{params}\n"
        end
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
