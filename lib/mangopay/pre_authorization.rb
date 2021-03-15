module MangoPay

  # See http://docs.mangopay.com/api-references/payins/preauthorized-payin/
  class PreAuthorization < Resource
    include HTTPCalls::Update
    include HTTPCalls::Fetch

    def self.create(params, idempotency_key = nil)
      MangoPay.request(:post, "#{url}/card/direct", params, {}, idempotency_key)
    end

    def self.transactions(pre_authorization_id, filters = {})
      MangoPay.request(:get, "#{url}/#{pre_authorization_id}/transactions", {}, filters)
    end

  end
end
