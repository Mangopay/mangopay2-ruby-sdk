module MangoPay

  # See https://docs.mangopay.com/api-references/disputes/disputes/
  class Dispute < Resource
    include HTTPCalls::Fetch
    include HTTPCalls::Update
    class << self

      def close(dispute_id)
        MangoPay.request(:put, url(dispute_id) + "/close/")
      end

      # +contested_funds+: Money hash; see contest section @ https://docs.mangopay.com/api-references/disputes/disputes/
      def contest(dispute_id, contested_funds)
        MangoPay.request(:put, url(dispute_id) + "/submit/", {ContestedFunds: contested_funds})
      end

      def resubmit(dispute_id)
        MangoPay.request(:put, url(dispute_id) + "/submit/")
      end

      def transactions(dispute_id, filters = {})
        MangoPay.request(:get, url(dispute_id) + "/transactions/", {}, filters)
      end

      def fetch_for_user(user_id, filters = {})
        url = "#{MangoPay.api_path}/users/#{user_id}/disputes"
        MangoPay.request(:get, url, {}, filters)
      end

      def fetch_for_wallet(wallet_id, filters = {})
        url = "#{MangoPay.api_path}/wallets/#{wallet_id}/disputes"
        MangoPay.request(:get, url, {}, filters)
      end

      def fetch_repudiation(repudiation_id)
        url = "#{MangoPay.api_path}/repudiations/#{repudiation_id}"
        MangoPay.request(:get, url)
      end

      def create_settlement_transfer(repudiation_id, params)
        url = "#{MangoPay.api_path}/repudiations/#{repudiation_id}/settlementtransfer/"
        MangoPay.request(:post, url, params)
      end

    end
  end
end
