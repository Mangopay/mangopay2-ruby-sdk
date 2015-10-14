module MangoPay
  class Transaction < Resource
    class << self
      # Fetches list of transactions belonging to the given +wallet_id+.
      # See also transactions for user: MangoPay::User#transactions
      # 
      # Optional +filters+ is a hash accepting following keys:
      # - +page+, +per_page+, +sort+: pagination and sorting params (see MangoPay::HTTPCalls::Fetch::ClassMethods#fetch)
      # - +Status+: TransactionStatus {CREATED, SUCCEEDED, FAILED}
      # - +Type+: TransactionType {PAYIN, PAYOUT, TRANSFER}
      # - +Nature+: TransactionNature {NORMAL, REFUND, REPUDIATION}
      # - +BeforeDate+ (timestamp): filters transactions with CreationDate _before_ this date
      # - +AfterDate+ (timestamp): filters transactions with CreationDate _after_ this date
      def fetch(wallet_id, filters={})
        MangoPay.request(:get, url(wallet_id), {}, filters)
      end

      def url(wallet_id)
        "#{MangoPay.api_path}/wallets/#{CGI.escape(wallet_id.to_s)}/transactions"
      end
    end
  end
end
