module MangoPay

  # See https://docs.mangopay.com/endpoints/v2.01/reporting
  class Report < Resource
    include HTTPCalls::Fetch

    class << self

      # +params+: hash; see https://docs.mangopay.com/endpoints/v2.01/reporting#e825_create-a-transaction-report
      def create(params, idempotency_key = nil)
        if params[:ReportType] == 'transactions'
          url = url() + '/transactions/'
        elsif params[:ReportType] == 'wallets'
          url = url() + '/wallets/'
        else
          raise 'When creating a report, ReportType is required. Ex: ("transactions", "wallets")'
        end

        MangoPay.request(:post, url, params, {}, idempotency_key)
      end

    end
  end
end
