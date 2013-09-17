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

  def self.request(method, url, params={}, headers={})
    uri = api_uri(url)

    res = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      request = Net::HTTP::const_get(method.capitalize).new(uri.request_uri, request_headers)
      request.body = MangoPay::JSON.dump(params)
      http.request request
    end
    MangoPay::JSON.load(res.body)
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
