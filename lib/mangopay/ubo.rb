module MangoPay
  # Provides API methods for the UBO entity.
  class Ubo < Resource
    class << self
      def url(user_id, ubo_declaration_id, id = nil)
        if id
          "#{MangoPay.api_path}/users/#{user_id}/kyc/ubodeclarations/#{ubo_declaration_id}/ubos/#{id}"
        else
          "#{MangoPay.api_path}/users/#{user_id}/kyc/ubodeclarations/#{ubo_declaration_id}/ubos"
        end
      end

      def create(user_id, ubo_declaration_id, params, idempotency_key = nil)
        MangoPay.request(:post, url(user_id, ubo_declaration_id), params, {}, idempotency_key)
      end

      def fetch(user_id, ubo_declaration_id, ubo_id)
        MangoPay.request(:get, url(user_id, ubo_declaration_id, ubo_id))
      end

      def update(user_id, ubo_declaration_id, ubo_id, params, idempotency_key = nil)
        MangoPay.request(:put, url(user_id, ubo_declaration_id, ubo_id), params, {}, idempotency_key)
      end
    end
  end
end
