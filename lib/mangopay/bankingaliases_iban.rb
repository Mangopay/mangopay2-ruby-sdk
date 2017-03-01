module MangoPay

  # See parent class MangoPay::BankingAliases
  class BankingAliasesIBAN < BankingAliases

    def self.create(params, wallet_id)
      url = "#{MangoPay.api_path}/wallets/#{wallet_id}/bankingaliases/iban"
      MangoPay.request(:post, url, params, {})
    end

    def self.url(id = nil)
      "#{super.url(id)}"
    end

  end
end
