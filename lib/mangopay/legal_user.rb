module MangoPay
  class LegalUser < User

    def self.url(id = nil)
      if id
        "#{MangoPay.api_path}/users/legal/#{CGI.escape(id.to_s)}"
      else
        "#{MangoPay.api_path}/users/legal"
      end
    end
  end
end
