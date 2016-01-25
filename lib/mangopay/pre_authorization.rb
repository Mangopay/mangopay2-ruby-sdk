module MangoPay

  # See http://docs.mangopay.com/api-references/payins/preauthorized-payin/
  class PreAuthorization < Resource
    include HTTPCalls::Update
    include HTTPCalls::Fetch

    def self.create(params, idempotency_key = nil)
      MangoPay.request(:post, "#{url}/card/direct", params, {}, idempotency_key)
    end

  end
end
