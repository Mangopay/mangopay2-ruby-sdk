require_relative '../../lib/mangopay/api/service/oauth_tokens'
require_relative '../../lib/mangopay/api/http_client'
require_relative '../../lib/mangopay/common/response_error'
require_relative '../context/user_context'

describe MangoApi::OAuthTokens do
  include_context 'user_context'

  describe '.create' do

    context 'having a valid configuration' do
      config = MangoPay.configuration

      it 'creates a valid authorization token' do
        token = MangoApi::OAuthTokens.create(config)
        # noinspection RubyStringKeysInHashInspection
        headers = {
          'Authorization' => "#{token['token_type']} #{token['access_token']}",
          'User-Agent' => "MangoPay V2 SDK Ruby Bindings v4/#{MangoPay::VERSION}",
          'Content-Type' => 'application/json'
        }
        url = 'https://api.sandbox.mangopay.com/v2.01/sdk-unit-tests/users/natural'
        # noinspection RubyResolve
        user = NATURAL_USER_DATA
        begin
          # launch a request to the MangoPay server using
          # the newly-created token as Authorization header
          MangoApi::HttpClient.post_raw(URI(url)) do |request|
            request.body = user.jsonify!
            headers.each do |k, v|
              request.add_field(k, v)
            end
          end
        rescue MangoApi::ResponseError => e
          raise "unsuccessful request using created token\n"\
                "#{e.code} #{e.details}\n#{e.message}"
        end
      end
    end
  end
end