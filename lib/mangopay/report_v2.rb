module MangoPay

  # See https://docs.mangopay.com/endpoints/v2.01/reporting
  class ReportV2 < Resource

    class << self
      def create(params, idempotency_key = nil)
        MangoPay.request(:post, "#{MangoPay.api_path}/reporting/reports", params, {}, idempotency_key)
      end

      def get(id)
        MangoPay.request(:get, "#{MangoPay.api_path}/reporting/reports/#{id}")
      end

      def get_all(params = nil)
        MangoPay.request(:get, "#{MangoPay.api_path}/reporting/reports", params)
      end

    end
  end
end
