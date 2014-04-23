module MangoPay
  class LegalUser < User

    def self.url(id = nil)
      if id
        "/v2/#{MangoPay.configuration.client_id}/users/legal/#{CGI.escape(id.to_s)}"
      else
        "/v2/#{MangoPay.configuration.client_id}/users/legal"
      end
    end
  end
end
