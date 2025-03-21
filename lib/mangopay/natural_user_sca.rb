module MangoPay

  # See https://docs.mangopay.com/api-reference/users/natural-user-object-sca
  class NaturalUserSca < User

    def self.url(id = nil)
      if id
        "#{MangoPay.api_path}/sca/users/natural/#{CGI.escape(id.to_s)}"
      else
        "#{MangoPay.api_path}/sca/users/natural"
      end
    end
  end
end
