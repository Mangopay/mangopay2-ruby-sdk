module MangoPay
  class Transaction < Resource
    include MangoPay::HTTPCalls::Fetch

    private

    def self.url(id)
      "/v2/#{MangoPay.configuration.client_id}/wallets/#{CGI.escape(id.to_s)}/transactions"
    end
  end
end
