module MangoPay

  # See http://docs.mangopay.com/api-references/payins/preauthorized-payin/
  class PreAuthorization < Resource
    include HTTPCalls::Update
    include HTTPCalls::Fetch

    def self.create(params)
      MangoPay.request(:post, "#{url}/card/direct", params)
    end

  end
end
