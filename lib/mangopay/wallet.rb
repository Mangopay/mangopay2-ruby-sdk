module MangoPay
  class Wallet < Resource
    include MangoPay::HTTPCalls::Create
    include MangoPay::HTTPCalls::Update
    include MangoPay::HTTPCalls::Fetch

    # Fetches list of transactions belonging to the given +wallet_id+.
    # Optional +filters+ is a hash accepting following keys:
    # - +page+, +per_page+: pagination params (see MangoPay::HTTPCalls::Fetch::ClassMethods#fetch)
    # - other keys specific for transactions filtering (see MangoPay::Transaction.fetch)
    def self.transactions(wallet_id, filters={})
      MangoPay::Transaction.fetch(wallet_id, filters)
    end
  end
end
