module MangoPay
  class PayOut < Resource
    include HTTPCalls::Fetch

    # Fetches list of refunds belonging to the given +pay_out_id+.
    #
    # Optional +filters+ is a hash accepting following keys:
    # - +page+, +per_page+, +sort+: pagination and sorting params (see MangoPay::HTTPCalls::Fetch::ClassMethods#fetch)
    # - +Status+: TransactionStatus {CREATED, SUCCEEDED, FAILED}
    # - +ResultCode+: string representing the transaction result
    def self.refunds(pay_out_id, filters = {}, idempotency_key = nil)
      url = url(pay_out_id) + '/refunds'
      MangoPay.request(:get, url, {}, filters, idempotency_key)
    end

    # See http://docs.mangopay.com/api-references/pay-out-bank-wire/
    class BankWire < Resource
      include HTTPCalls::Create

      def self.url(*)
        "#{MangoPay.api_path}/payouts/bankwire"
      end
    end
  end
end
