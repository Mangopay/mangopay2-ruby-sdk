require 'base64'

module MangoPay
  class Client < Resource

    class << self

      def create(params)
        MangoPay.request(:post, '/api/clients/', params, {}, {
          'user_agent' => "MangoPay V2 RubyBindings/#{VERSION}",
          'Content-Type' => 'application/json'
        })
      end

      # see https://docs.mangopay.com/api-references/client-details/
      def fetch()
        MangoPay.request(:get, url())
      end

      # see https://docs.mangopay.com/api-references/client-details/
      def update(params)
        MangoPay.request(:put, url(), params)
      end

      # see https://docs.mangopay.com/api-references/client-details/
      def upload_logo(file_content_base64, file_path = nil)
        if file_content_base64.nil? && !file_path.nil?
          bts = File.open(file_path, 'rb') { |f| f.read }
          file_content_base64 = Base64.encode64(bts)
        end
        # normally it returns 204 HTTP code on success
        begin
          MangoPay.request(:put, url() + '/logo', {'File' => file_content_base64})
        rescue ResponseError => ex
          raise ex unless ex.code == '204'
        end
      end

    end
  end
end
