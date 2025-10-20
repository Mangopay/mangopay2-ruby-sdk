module MangoPay

  # See http://docs.mangopay.com/api-references/users/
  # See also children classes:
  # - MangoPay::NaturalUser
  # - MangoPay::LegalUser
  # - MangoPay::NaturalUserSca
  # - MangoPay::LegalUserSca
  class User < Resource
    include HTTPCalls::Create
    include HTTPCalls::Update
    include HTTPCalls::Fetch
    class << self
      def enroll_sca(user_id, idempotency_key = nil)
        url = "#{MangoPay.api_path}/sca/users/#{user_id}/enrollment"
        MangoPay.request(:post, url, {}, {}, idempotency_key)
      end

      def manage_consent(user_id, idempotency_key = nil)
        url = "#{MangoPay.api_path}/sca/users/#{user_id}/consent"
        MangoPay.request(:post, url, {}, {}, idempotency_key)
      end

      # Fetches list of wallets belonging to the given +user_id+.
      # Optional +filters+ is a hash accepting following keys:
      # - +page+, +per_page+, +sort+: pagination and sorting params (see MangoPay::HTTPCalls::Fetch::ClassMethods#fetch)
      def wallets(user_id, filters = {})
        MangoPay.request(:get, url(user_id) + '/wallets', {}, filters)
      end

      # Fetches list of bank accounts belonging to the given +user_id+.
      # Optional +filters+ is a hash accepting following keys:
      # - +page+, +per_page+, +sort+: pagination and sorting params
      # (see MangoPay::HTTPCalls::Fetch::ClassMethods#fetch)
      def bank_accounts(user_id, filters = {})
        MangoPay.request(:get, url(user_id) + '/bankaccounts', {}, filters)
      end

      # Fetches list of cards belonging to the given +user_id+.
      # Optional +filters+ is a hash accepting following keys:
      # - +page+, +per_page+, +sort+: pagination and sorting params (see MangoPay::HTTPCalls::Fetch::ClassMethods#fetch)
      def cards(user_id, filters = {})
        MangoPay.request(:get, url(user_id) + '/cards', {}, filters)
      end

      # Fetches list of transactions belonging to the given +user_id+.
      # Optional +filters+ is a hash accepting following keys:
      # - +page+, +per_page+, +sort+: pagination and sorting params (see MangoPay::HTTPCalls::Fetch::ClassMethods#fetch)
      # - other keys specific for transactions filtering (see MangoPay::Transaction#fetch)
      def transactions(user_id, filters = {})
        MangoPay.request(:get, url(user_id) + '/transactions', {}, filters)
      end

      # View EMoney belonging to the given +user_id+.
      # Optional +filters+ is a hash accepting following keys:
      # - +page+, +per_page+, +sort+: pagination and sorting params (see MangoPay::HTTPCalls::Fetch::ClassMethods#fetch)
      # - other keys specific for transactions filtering (see MangoPay::Transaction#fetch)
      def emoney(user_id, year, month = nil, filters = {})
        if month
          MangoPay.request(:get, url(user_id) + "/emoney/#{year}/#{month}", {}, filters)
        else
          MangoPay.request(:get, url(user_id) + "/emoney/#{year}", {}, filters)
        end
      end

      # Fetches list of kyc documents belonging to the given +user_id+.
      # Optional +filters+ is a hash accepting following keys:
      # - +page+, +per_page+, +sort+, +BeforeDate+, +AfterDate+, +Status+: pagination and sorting params (see MangoPay::HTTPCalls::Fetch::ClassMethods#fetch)
      def kyc_documents(user_id, filters = {})
        MangoPay.request(:get, url(user_id) + '/KYC/documents', {}, filters)
      end

      # Fetches list of pre-authorizations belonging to the given +user_id+.
      # Optional +filters+ is a hash accepting the following keys:
      # - +page+, +per_page+, +sort+, +Status+, +ResultCode+, +PaymentStatus+: pagination and sorting/filtering params (see MangoPay::HTTPCalls::Fetch::ClassMethods#fetch)
      def pre_authorizations(user_id, filters = {})
        MangoPay.request(:get, url(user_id) + '/preauthorizations', {}, filters)
      end

      # Fetches User Block Status
      def block_status(user_id, filters = {})
        MangoPay.request(:get, url(user_id) + '/blockStatus', {}, filters)
      end

      # Fetches User Regulatory
      def regulatory(user_id, filters = {})
        MangoPay.request(:get, url(user_id) + '/Regulatory', {}, filters)
      end

      def fetch_sca(user_id)
        url = "#{MangoPay.api_path}/sca/users/#{user_id}"
        MangoPay.request(:get, url, {}, {})
      end

      def validate_data_format(params, idempotency_key = nil)
        MangoPay.request(:post, "#{MangoPay.api_path}/users/data-formats/validation", params, {}, idempotency_key)
      end
    end
  end
end
