module MangoPay
  class NaturalUser < User

    def self.url(id = nil)
      if id
        "#{MangoPay.api_path}/users/natural/#{CGI.escape(id.to_s)}"
      else
        "#{MangoPay.api_path}/users/natural"
      end
    end
  end
end
