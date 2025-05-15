module MangoPay

  # See http://docs.mangopay.com/api-references/payins/preauthorized-payin/
  class Deposit < Resource
    def self.create(params, idempotency_key = nil)
      MangoPay.request(:post, "#{MangoPay.api_path}/deposit-preauthorizations/card/direct", params, {}, idempotency_key)
    end

    def self.get(deposit_id, filters = {})
      MangoPay.request(:get, "#{MangoPay.api_path}/deposit-preauthorizations/#{deposit_id}", {}, filters)
    end

    def self.cancel(deposit_id)
      params = {
        PaymentStatus: 'CANCELED'
      }
      MangoPay.request(:put, "#{MangoPay.api_path}/deposit-preauthorizations/#{deposit_id}", params)
    end

    def self.update(deposit_id, params)
      MangoPay.request(:put, "#{MangoPay.api_path}/deposit-preauthorizations/#{deposit_id}", params)
    end

    def self.get_all_for_user(user_id, filters = {})
      MangoPay.request(:get, "#{MangoPay.api_path}/users/#{user_id}/deposit-preauthorizations", {}, filters)
    end

    def self.get_all_for_card(card_id, filters = {})
      MangoPay.request(:get, "#{MangoPay.api_path}/cards/#{card_id}/deposit-preauthorizations", {}, filters)
    end
  end
end
