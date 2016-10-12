module MangoPay

  # See https://docs.mangopay.com/endpoints/v2.01/reporting
  class Report < Resource
    include HTTPCalls::Fetch

    class << self

      # +params+: hash; see https://docs.mangopay.com/endpoints/v2.01/reporting#e825_create-a-transaction-report
      def create(params, idempotency_key = nil)
        url = url() + '/transactions/'
        MangoPay.request(:post, url, params, {}, idempotency_key)
      end

    end
  end
end
