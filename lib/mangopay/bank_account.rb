module MangoPay

  # See http://docs.mangopay.com/api-references/bank-accounts/
  class BankAccount < Resource
    include HTTPCalls::Fetch
    class << self
      def create(user_id, params, idempotency_key = nil)
        type = params.fetch(:Type) { |no_symbol_key| params.fetch('Type') }
        MangoPay.request(:post, "#{url(user_id)}/#{type}", params, {}, idempotency_key)
      end

      # Fetches:
      # - list of bank accounts belonging to the given +user_id+
      # - or single bank account belonging to the given +user_id+ with the given +bank_account_id+.
      #
      # In case of list query, optional +filters+ is a hash accepting pagination and sorting params
      # (+page+, +per_page+, +sort+; see MangoPay::HTTPCalls::Fetch::ClassMethods#fetch)
      #
      def fetch(user_id, bank_account_id_or_filters={})
        bank_account_id, filters = HTTPCalls::Fetch.parse_id_or_filters(bank_account_id_or_filters)
        MangoPay.request(:get, url(user_id, bank_account_id), {}, filters)
      end

      # see https://docs.mangopay.com/endpoints/v2.01/bank-accounts#e306_disactivate-a-bank-account
      def update(user_id, bank_account_id, params = {})
        MangoPay.request(:put, url(user_id, bank_account_id), params)
      end

      def url(user_id, bank_account_id = nil)
        if bank_account_id
          "#{MangoPay.api_path}/users/#{CGI.escape(user_id.to_s)}/bankaccounts/#{CGI.escape(bank_account_id.to_s)}"
        else
          "#{MangoPay.api_path}/users/#{CGI.escape(user_id.to_s)}/bankaccounts"
        end
      end
    end
  end
end
