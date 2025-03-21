module MangoPay

  # See https://docs.mangopay.com/api-reference/users/legal-user-object-sca
  class LegalUserSca < User

    def self.url(id = nil)
      if id
        "#{MangoPay.api_path}/sca/users/legal/#{CGI.escape(id.to_s)}"
      else
        "#{MangoPay.api_path}/sca/users/legal"
      end
    end

    class << self
    end
  end
end
