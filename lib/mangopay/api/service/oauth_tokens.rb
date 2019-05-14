require_relative '../uri_provider'

module MangoApi

  # Provides API method delegates for OAuth authentication.
  module OAuthTokens
    class << self
      include UriProvider

      # Creates a new configuration-specific authorization token.
      #
      # @param +mangopay_config+ The MangoPay environment configuration
      def create(mangopay_config)
        uri = provide_uri(:create_token)
        HttpClient.post_raw(uri) do |request|
          config = mangopay_config
          request.basic_auth config.client_id, config.client_apiKey
          request.body = 'grant_type=client_credentials'
          request.add_field('Content-Type',
                            'application/x-www-form-urlencoded')
        end
      end
    end
  end
end