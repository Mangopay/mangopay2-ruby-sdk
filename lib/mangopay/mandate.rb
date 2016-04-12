module MangoPay

  # See https://docs.mangopay.com/api-references/mandates/
  class Mandate < Resource
    include HTTPCalls::Fetch

    class << self

      # +params+: hash; see https://docs.mangopay.com/api-references/mandates/
      def create(params, idempotency_key = nil)
        url = "#{MangoPay.api_path}/mandates/directdebit/web"
        MangoPay.request(:post, url, params, {}, idempotency_key)
      end

      def cancel(id)
        url = "#{MangoPay.api_path}/mandates/#{id}/cancel"
        MangoPay.request(:put, url)
      end

      def fetch_for_user(user_id, filters = {})
        url = "#{MangoPay.api_path}/users/#{user_id}/mandates"
        MangoPay.request(:get, url, {}, filters)
      end

      def fetch_for_user_bank_account(user_id, bank_account_id, filters = {})
        url = "#{MangoPay.api_path}/users/#{user_id}/bankaccounts/#{bank_account_id}/mandates"
        MangoPay.request(:get, url, {}, filters)
      end

    end
  end
end
