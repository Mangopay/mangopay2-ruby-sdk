require 'net/http'
require 'cgi/util'
require 'multi_json'

# helpers
require 'mangopay/version'
require 'mangopay/json'
require 'mangopay/errors'
require 'mangopay/authorization_token'

# resources
require 'mangopay/http_calls'
require 'mangopay/resource'
require 'mangopay/client'
require 'mangopay/user'
require 'mangopay/natural_user'
require 'mangopay/legal_user'
require 'mangopay/payin'
require 'mangopay/payout'
require 'mangopay/transfer'
require 'mangopay/transaction'
require 'mangopay/wallet'
require 'mangopay/bank_account'
require 'mangopay/card_registration'
require 'mangopay/card'

module MangoPay

  class Configuration
    attr_accessor :preproduction, :root_url,
      :client_id, :client_passphrase,
      :temp_dir

    def preproduction
      @preproduction || false
    end

    def root_url
      @root_url || (@preproduction == true  ? "https://mangopay-api-inte.leetchi.com" : "https://api.leetchi.com")
    end
  end

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield configuration
  end

  def self.api_uri(url='')
    URI(configuration.root_url + url)
  end

  #
  # - +method+: HTTP method; lowercase symbol, e.g. :get, :post etc.
  # - +url+: the part after Configuration#root_url
  # - +params+: hash; entity data for creation, update etc.; will dump it by JSON and assign to Net::HTTPRequest#body
  # - +filters+: hash; pagination params etc.; will encode it by URI and assign to URI#query
  # - +headers+: hash; request_headers by default
  # - +before_request_proc+: optional proc; will call it passing the Net::HTTPRequest instance just before Net::HTTPRequest#request
  #
  # Raises MangoPay::ResponseError if response code != 200.
  #
  def self.request(method, url, params={}, filters={}, headers = request_headers, before_request_proc = nil)
    uri = api_uri(url)
    uri.query = URI.encode_www_form(filters) unless filters.empty?

    res = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      req = Net::HTTP::const_get(method.capitalize).new(uri.request_uri, headers)
      req.body = MangoPay::JSON.dump(params)
      before_request_proc.call(req) if before_request_proc
      http.request req
    end

    # decode json data
    begin
      data = MangoPay::JSON.load(res.body)
    rescue MultiJson::LoadError
      data = {}
    end

    raise MangoPay::ResponseError.new(uri, res.code, data) unless res.is_a? Net::HTTPOK

    # copy pagination info if any
    ['x-number-of-pages', 'x-number-of-items'].each { |k|
      filters[k.gsub('x-number-of-', 'total_')] = res[k].to_i if res[k]
    }

    data
  end

  private

  def self.user_agent
    @uname ||= get_uname

    {
      bindings_version: MangoPay::VERSION,
      lang: 'ruby',
      lang_version: "#{RUBY_VERSION} p#{RUBY_PATCHLEVEL} (#{RUBY_RELEASE_DATE})",
      platform: RUBY_PLATFORM,
      uname: @uname
    }
  end

  def self.get_uname
    `uname -a 2>/dev/null`.strip if RUBY_PLATFORM =~ /linux|darwin/i
  rescue Errno::ENOMEM
    'uname lookup failed'
  end

  def self.request_headers
    auth_token = MangoPay::AuthorizationToken::Manager.get_token
    headers = {
      'user_agent' => "MangoPay V1 RubyBindings/#{MangoPay::VERSION}",
      'Authorization' => "#{auth_token['token_type']} #{auth_token['access_token']}",
      'Content-Type' => 'application/json'
    }
    begin
      headers.update('x_mangopay_client_user_agent' => MangoPay::JSON.dump(user_agent))
    rescue => e
      headers.update('x_mangopay_client_raw_user_agent' => user_agent.inspect, error: "#{e} (#{e.class})")
    end
  end
end
