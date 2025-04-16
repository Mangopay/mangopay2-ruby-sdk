module MangoPay

  # See http://docs.mangopay.com/api-references/users/natural-users/
  class NaturalUser < User

    def self.url(id = nil)
      if id
        "#{MangoPay.api_path}/users/natural/#{CGI.escape(id.to_s)}"
      else
        "#{MangoPay.api_path}/users/natural"
      end
    end

    class << self
      def close(user_id)
        MangoPay.request(:delete, url(user_id))
      end
    end
  end
end
