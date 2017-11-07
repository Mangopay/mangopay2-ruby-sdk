module MangoPay

  # See http://docs.mangopay.com/api-references/users/
  # See also children classes:
  # - MangoPay::NaturalUser
  # - MangoPay::LegalUser
  class User < Resource
    include HTTPCalls::Create
    include HTTPCalls::Update
    include HTTPCalls::Fetch
    class << self
      # Fetches list of wallets belonging to the given +user_id+.
      # Optional +filters+ is a hash accepting following keys:
      # - +page+, +per_page+, +sort+: pagination and sorting params (see MangoPay::HTTPCalls::Fetch::ClassMethods#fetch)
      def wallets(user_id, filters={})
        MangoPay.request(:get, url(user_id) + '/wallets', {}, filters)
      end

      # Fetches list of bank accounts belonging to the given +user_id+.
      # Optional +filters+ is a hash accepting following keys:
      # - +page+, +per_page+, +sort+: pagination and sorting params
      # (see MangoPay::HTTPCalls::Fetch::ClassMethods#fetch)
      def bank_accounts(user_id, filters={})
        MangoPay.request(:get, url(user_id) + '/bankaccounts', {}, filters)
      end

      # Fetches list of cards belonging to the given +user_id+.
      # Optional +filters+ is a hash accepting following keys:
      # - +page+, +per_page+, +sort+: pagination and sorting params (see MangoPay::HTTPCalls::Fetch::ClassMethods#fetch)
      def cards(user_id, filters={})
        MangoPay.request(:get, url(user_id) + '/cards', {}, filters)
      end

      # Fetches list of transactions belonging to the given +user_id+.
      # Optional +filters+ is a hash accepting following keys:
      # - +page+, +per_page+, +sort+: pagination and sorting params (see MangoPay::HTTPCalls::Fetch::ClassMethods#fetch)
      # - other keys specific for transactions filtering (see MangoPay::Transaction#fetch)
      def transactions(user_id, filters={})
        MangoPay.request(:get, url(user_id) + '/transactions', {}, filters)
      end

      # View EMoney belonging to the given +user_id+.
      # Optional +filters+ is a hash accepting following keys:
      # - +page+, +per_page+, +sort+: pagination and sorting params (see MangoPay::HTTPCalls::Fetch::ClassMethods#fetch)
      # - other keys specific for transactions filtering (see MangoPay::Transaction#fetch)
      def emoney(user_id, filters={})
        MangoPay.request(:get, url(user_id) + '/emoney', {}, filters)
      end

      # Fetches list of kyc documents belonging to the given +user_id+.
      # Optional +filters+ is a hash accepting following keys:
      # - +page+, +per_page+, +sort+, +BeforeDate+, +AfterDate+, +Status+: pagination and sorting params (see MangoPay::HTTPCalls::Fetch::ClassMethods#fetch)
      def kyc_documents(user_id, filters={})
        MangoPay.request(:get, url(user_id) + '/KYC/documents', {}, filters)
      end
    end
  end
end
