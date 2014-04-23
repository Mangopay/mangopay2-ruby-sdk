module MangoPay
  class Transaction < Resource
    class << self
      # Fetches list of transactions belonging to the given +wallet_id+.
      # 
      # Optional +filters+ is a hash accepting following keys:
      # - +page+, +per_page+: pagination params (see MangoPay::HTTPCalls::Fetch::ClassMethods#fetch)
      # - +Status+: TransactionStatus {CREATED, SUCCEEDED, FAILED}
      # - +Type+: TransactionType {PAYIN, PAYOUT, TRANSFER}
      # - +Nature+: TransactionNature {NORMAL, REFUND, REPUDIATION}
      # - +Direction+: TransactionDirection {DEBIT, CREDIT}
      # - +BeforeDate+ (timestamp): filters transactions with CreationDate _before_ this date
      # - +AfterDate+ (timestamp): filters transactions with CreationDate _after_ this date
      #
      def fetch(wallet_id, filters={})
        MangoPay.request(:get, url(wallet_id), {}, filters)
      end

      def url(wallet_id)
        "/v2/#{MangoPay.configuration.client_id}/wallets/#{CGI.escape(wallet_id.to_s)}/transactions"
      end
    end
  end
end
