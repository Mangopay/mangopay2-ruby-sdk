module MangoPay

  # See http://docs.mangopay.com/api-references/wallets/
  class Wallet < Resource
    include HTTPCalls::Create
    include HTTPCalls::Update
    include HTTPCalls::Fetch

    # Fetches list of transactions belonging to the given +wallet_id+.
    # Optional +filters+ is a hash accepting following keys:
    # - +page+, +per_page+, +sort+: pagination and sorting params (see MangoPay::HTTPCalls::Fetch::ClassMethods#fetch)
    # - other keys specific for transactions filtering (see MangoPay::Transaction.fetch)
    def self.transactions(wallet_id, filters = {}, headers = nil)
      Transaction.fetch(wallet_id, filters, headers)
    end
  end
end
