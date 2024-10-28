module MangoPay

  class VirtualAccount < Resource
    include HTTPCalls::Create
    include HTTPCalls::Update
    include HTTPCalls::Fetch

    class << self

      # Updates:
      # - irreversibly deactivates a virtual account with +virtual_account_id+
      # see https://docs.mangopay.com/api-reference/virtual-accounts/deactivate-virtual-account
      def deactivate(wallet_id, virtual_account_id)
        url = "#{MangoPay.api_path}/wallets/#{wallet_id}/virtual-accounts/#{virtual_account_id}"
        MangoPay.request(:put, url)
      end

      # Fetches:
      # - view a virtual account with +virtual_account_id+
      # see https://docs.mangopay.com/api-reference/virtual-accounts/view-virtual-account
      def fetch(wallet_id, virtual_account_id)
        url = "#{MangoPay.api_path}/wallets/#{wallet_id}/virtual-accounts/#{virtual_account_id}"
        MangoPay.request(:get, url, {})
      end

      # Fetches:
      # - view virtual accounts for given +wallet_id+
      # see https://docs.mangopay.com/api-reference/virtual-accounts/list-virtual-accounts-wallet
      def fetch_all(wallet_id, filters = {})
        url = "#{MangoPay.api_path}/wallets/#{wallet_id}/virtual-accounts"
        MangoPay.request(:get, url, {}, filters)
      end

      # Fetches:
      # Allows to check which account countries and currencies are available
      # see https://docs.mangopay.com/api-reference/virtual-accounts/view-virtual-account-availabilities
      def fetch_availabilities(filters = {})
        url = "#{MangoPay.api_path}/virtual-accounts/availability"
        MangoPay.request(:get, url, {}, filters)
      end
    end
  end
end