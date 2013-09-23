module MangoPay
  class NaturalUser < User

    private

    def self.url(id = nil)
      if id
        "/v2/#{MangoPay.configuration.client_id}/users/natural/#{CGI.escape(id.to_s)}"
      else
        "/v2/#{MangoPay.configuration.client_id}/users/natural"
      end
    end
  end
end
