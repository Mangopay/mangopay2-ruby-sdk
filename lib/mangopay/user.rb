module MangoPay
  class User < Resource
    include MangoPay::HTTPCalls::Create
    include MangoPay::HTTPCalls::Update
    include MangoPay::HTTPCalls::Fetch
    class << self
      # Fetches list of wallets belonging to the given +user_id+.
      # Optional +filters+ is a hash accepting following keys:
      # - +page+, +per_page+: pagination params (see MangoPay::HTTPCalls::Fetch::ClassMethods#fetch)
      # - other keys specific for transactions filtering (see MangoPay::Transaction.fetch)
      def wallets(user_id, filters={})
        MangoPay.request(:get, url(user_id) + '/wallets', {}, filters)
      end

      # Fetches list of cards belonging to the given +user_id+.
      # Optional +filters+ is a hash accepting following keys:
      # - +page+, +per_page+: pagination params (see MangoPay::HTTPCalls::Fetch::ClassMethods#fetch)
      def cards(user_id, filters={})
        MangoPay.request(:get, url(user_id) + '/cards', {}, filters)
      end

      # Fetches list of transactions belonging to the given +user_id+.
      # Optional +filters+ is a hash accepting following keys:
      # - +page+, +per_page+: pagination params (see MangoPay::HTTPCalls::Fetch::ClassMethods#fetch)
      def transactions(user_id, filters={})
        MangoPay.request(:get, url(user_id) + '/transactions', {}, filters)
      end
    end
  end
end
