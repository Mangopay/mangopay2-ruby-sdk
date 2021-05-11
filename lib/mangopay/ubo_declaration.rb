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

      def create(user_id, idempotency_key)
        MangoPay.request(:post, url(user_id), {}, {}, idempotency_key)
      end

      def fetch(user_id, id, idempotency_key)
        MangoPay.request(:get, url(user_id, id), {}, {}, idempotency_key)
      end

      def update(user_id, id, params = {}, idempotency_key)
        request_params = {
            Status: params['Status'],
            Ubos: params['Ubos']
        }
        MangoPay.request(:put, url(user_id, id), request_params, {}, idempotency_key)
      end
    end
  end
end
