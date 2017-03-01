module MangoPay

  # See children class:
  # - MangoPay::BankingAliasesIBAN
  class BankingAliases < Resource
    include HTTPCalls::Create
    include HTTPCalls::Update
    include HTTPCalls::Fetch

    class << self
      def create
        raise 'Cannot create a MangoPay::BankingAlias. See MangoPay::BankingAliasesIBAN'
      end

      def url(id = nil)
        if id
          "#{MangoPay.api_path}/bankingaliases/#{CGI.escape(id)}"
        else
          "#{MangoPay.api_path}/bankingaliases"
        end
      end

      def fetch_for_wallet(wallet_id, filters = {})
        url = "#{MangoPay.api_path}/wallets/#{wallet_id}/bankingaliases"
        MangoPay.request(:get, url, {}, filters)
      end
    end
  end
end
