module MangoPay
  class BankAccount < Resource
    include MangoPay::HTTPCalls::Fetch

    def self.create(user_id, params)
      type = params.fetch(:Type) { |no_symbol_key| params.fetch('Type') }
      MangoPay.request(:post, "#{url(user_id)}/#{type}", params)
    end

    # Fetches:
    # - list of bank accounts belonging to the given +user_id+
    # - or single bank account belonging to the given +user_id+ with the given +bank_account_id+.
    # 
    # In case of list query, optional +filters+ is a hash accepting pagination params
    # (+page+, +per_page+; see MangoPay::HTTPCalls::Fetch::ClassMethods#fetch)
    #
    def self.fetch(user_id, bank_account_id_or_filters={})
      bank_account_id, filters = MangoPay::HTTPCalls::Fetch.parse_id_or_filters(bank_account_id_or_filters)
      MangoPay.request(:get, url(user_id, bank_account_id), {}, filters)
    end

    private

    def self.url(user_id, bank_account_id = nil)
      if bank_account_id
        "/v2/#{MangoPay.configuration.client_id}/users/#{CGI.escape(user_id.to_s)}/bankaccounts/#{CGI.escape(bank_account_id.to_s)}"
      else
        "/v2/#{MangoPay.configuration.client_id}/users/#{CGI.escape(user_id.to_s)}/bankaccounts"
      end
    end
  end
end
