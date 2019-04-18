module MangoPay
  # Provides API methods for the UBO declaration entity.
  class UboDeclaration < Resource
    class << self
      def url(user_id, id = nil)
        if id
          "#{MangoPay.api_path}/users/#{user_id}/kyc/ubodeclarations/#{id}"
        else
          "#{MangoPay.api_path}/users/#{user_id}/kyc/ubodeclarations"
        end
      end

      def create(user_id)
        MangoPay.request(:post, url(user_id))
      end

      def fetch(user_id, id)
        MangoPay.request(:get, url(user_id, id))
      end

      def update(user_id, id, params = {})
        request_params = {
            Status: params['Status'],
            Ubos: params['Ubos']
        }
        MangoPay.request(:put, url(user_id, id), request_params)
      end
    end
  end
end
