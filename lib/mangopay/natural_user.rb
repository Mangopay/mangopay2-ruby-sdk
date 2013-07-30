module MangoPay
  class NaturalUser < User

    private

    def self.url(id = nil)
      if id
        "/v2/#{MangoPay.configuration.client_id}/users/naturals/#{CGI.escape(id)}"
      else
        "/v2/#{MangoPay.configuration.client_id}/users/naturals"
      end
    end
  end
end
