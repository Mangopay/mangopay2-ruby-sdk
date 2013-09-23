module MangoPay
  class BankAccount < Resource
    include MangoPay::HTTPCalls::Create
    include MangoPay::HTTPCalls::Fetch

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
