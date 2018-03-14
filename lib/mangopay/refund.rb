module MangoPay

  # See http://docs.mangopay.com/api-references/refund/
  class Refund < Resource
    include HTTPCalls::Fetch

    # Fetches list of refunds belonging to given +repudiation_id+
    #
    # Optional +filters+ is a hash accepting following keys:
    # - +page+, +per_page+, +sort+: pagination and sorting params (see MangoPay::HTTPCalls::Fetch::ClassMethods#fetch)
    # - +Status+: TransactionStatus {CREATED, SUCCEEDED, FAILED}
    # - +ResultCode+: string representing the transaction result
    def self.of_repudiation(repudiation_id, filters = {})
      url = "#{MangoPay.api_path}/repudiations/#{repudiation_id}/refunds"
      MangoPay.request(:get, url, {}, filters)
    end
  end
end
