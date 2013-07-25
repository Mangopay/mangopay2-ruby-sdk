require 'net/http'
require 'rest_client'
require 'multi_json'

# Version
require 'mangopay/version'

# JSON
require 'mangopay/json'

# Resources
require 'mangopay/http_calls'
require 'mangopay/resource'
require 'mangopay/client'
require 'mangopay/user'
require 'mangopay/natural_user'
require 'mangopay/legal_user'
require 'mangopay/payin'
require 'mangopay/payout'
require 'mangopay/transaction'
require 'mangopay/wallet'
require 'mangopay/bank_detail'

# Errors
require 'mangopay/errors'

module MangoPay

  class Configuration
    attr_accessor :root_url, :client_id, :client_passphrase, :preproduction

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
      puts method
      puts request.uri
      puts request.path
      request.body = MangoPay::JSON.dump(params)
      http.request request
    end
    puts res.body
    puts MangoPay::JSON.load(res.body)
    MangoPay::JSON.load(res.body)
  end

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
  rescue Errno::ENOMEM => ex
    "uname lookup failed"
  end

  def self.get_oauth_token
    uri = api_uri('/api/oauth/token')
    res = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      req = Net::HTTP::Post.new(uri.request_uri)
      req.basic_auth configuration.client_id, configuration.client_passphrase
      req.body = 'grant_type=client_credentials'
      http.request req
    end
    MangoPay::JSON.load(res.body)
  end

  def self.oauth_token
    oauth = get_oauth_token
    "#{oauth['token_type']} #{oauth['access_token']}"
  end

  def self.request_headers
    headers = {
      'user_agent' => "MangoPay V1 RubyBindings/#{MangoPay::VERSION}",
      'Authorization' => oauth_token,
      'Content-Type' => 'application/json'
    }
    begin
      headers.update('x_mangopay_client_user_agent' => MangoPay::JSON.dump(user_agent))
    rescue => e
      headers.update('x_mangopay_client_raw_user_agent' => user_agent.inspect, error: "#{e} (#{e.class})")
    end
  end
end
