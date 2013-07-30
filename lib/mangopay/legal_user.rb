module MangoPay
  class LegalUser < User

    private

    def self.url(id = nil)
      if id
        "/v2/#{MangoPay.configuration.client_id}/users/legals/#{CGI.escape(id)}"
      else
        "/v2/#{MangoPay.configuration.client_id}/users/legals"
      end
    end
  end
end
