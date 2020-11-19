module MangoPay

  # See parent class MangoPay::BankingAliases
  class BankingAliasesIBAN < BankingAliases

    def self.create(params, wallet_id, headers_or_idempotency_key = nil)
      url = "#{MangoPay.api_path}/wallets/#{wallet_id}/bankingaliases/iban"
      MangoPay.request(:post, url, params, {}, headers_or_idempotency_key)
    end

    def self.url(id = nil)
      "#{super.url(id)}"
    end

  end
end
