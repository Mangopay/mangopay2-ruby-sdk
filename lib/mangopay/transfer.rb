module MangoPay

  # See http://docs.mangopay.com/api-references/transfers/
  class Transfer < Resource
    include HTTPCalls::Create
    include HTTPCalls::Fetch
    include HTTPCalls::Refund

    # Fetches list of refunds belonging to given +transfer_id+.
    #
    # Optional +filters+ is a hash accepting following keys:
    # - +page+, +per_page+, +sort+: pagination and sorting params (see MangoPay::HTTPCalls::Fetch::ClassMethods#fetch)
    # - +Status+: TransactionStatus {CREATED, SUCCEEDED, FAILED}
    # - +ResultCode+: string representing the transaction result
    def self.refunds(transfer_id, filters = {})
      url = url(transfer_id) + '/refunds'
      MangoPay.request(:get, url, {}, filters)
    end
  end
end
