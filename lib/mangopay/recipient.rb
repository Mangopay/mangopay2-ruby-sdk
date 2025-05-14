module MangoPay

  class Recipient < Resource
    def self.create(params, user_id, idempotency_key = nil)
      MangoPay.request(:post, "#{MangoPay.api_path}/users/#{user_id}/recipients", params, {}, idempotency_key)
    end

    def self.get(recipient_id, filters = {})
      MangoPay.request(:get, "#{MangoPay.api_path}/recipients/#{recipient_id}", {}, filters)
    end

    def self.get_user_recipients(user_id, filters = {})
      MangoPay.request(:get, "#{MangoPay.api_path}/users/#{user_id}/recipients", {}, filters)
    end

    def self.get_schema(payout_method_type, recipient_type, currency, country, filters = {})
      MangoPay.request(:get, "#{MangoPay.api_path}/recipients/schema?payoutMethodType=#{payout_method_type}&recipientType=#{recipient_type}&currency=#{currency}&country=#{country}", {}, filters)
    end

    def self.get_payout_methods(country, currency, filters = {})
      MangoPay.request(:get, "#{MangoPay.api_path}/recipients/payout-methods?country=#{country}&currency=#{currency}", {}, filters)
    end

    def self.validate(params, user_id, idempotency_key = nil)
      MangoPay.request(:post, "#{MangoPay.api_path}/users/#{user_id}/recipients/validate", params, {}, idempotency_key)
    end

    def self.deactivate(recipient_id)
      params = {
        Status: 'DEACTIVATED'
      }
      MangoPay.request(:put, "#{MangoPay.api_path}/recipients/#{recipient_id}", params, {})
    end
  end
end
