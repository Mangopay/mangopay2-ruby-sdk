module MangoPay
  class BankAccount < Resource
    include MangoPay::HTTPCalls::Create
    include MangoPay::HTTPCalls::Fetch

    def self.fetch(*ids)
      url = ids.length == 1 ? url(ids[0]) : url(ids[0], ids[1])
      MangoPay.request(:get, url)
    end

    private

    def self.url(*id)
      if id.length == 1
        "/v2/#{MangoPay.configuration.client_id}/users/#{CGI.escape(id[0])}/bankaccounts"
      else
        "/v2/#{MangoPay.configuration.client_id}/users/#{CGI.escape(id[0])}/bankaccounts/#{CGI.escape(id[1])}"
      end
    end
  end
end
