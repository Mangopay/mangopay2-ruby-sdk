module MangoPay
  class PreAuthorization < Resource
    include MangoPay::HTTPCalls::Update
    include MangoPay::HTTPCalls::Fetch

    def self.create(params)
      MangoPay.request(:post, "#{url()}/card/direct", params)
    end

  end
end
