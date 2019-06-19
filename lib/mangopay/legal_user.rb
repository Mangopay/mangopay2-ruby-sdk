module MangoPay

  # See http://docs.mangopay.com/api-references/users/legal-users/
  # See also parent class MangoPay::User
  class LegalUser < User

    def self.url(id = nil)
      if id
        "#{MangoPay.api_path}/users/legal/#{CGI.escape(id.to_s)}"
      else
        "#{MangoPay.api_path}/users/legal"
      end
    end

    class << self
    end
  end
end
