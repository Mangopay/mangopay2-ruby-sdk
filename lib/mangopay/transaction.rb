module MangoPay
  class Transaction < Resource
    include MangoPay::HTTPCalls::Fetch

    def self.url(id)
      "/v2/#{MangoPay.configuration.client_id}/wallets/#{CGI.escape(id)}/transactions"
    end
  end
end
