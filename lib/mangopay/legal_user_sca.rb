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
      def categorize(user_id, params)
        url = "#{MangoPay.api_path}/sca/users/legal/#{user_id}/category"
        MangoPay.request(:put, url, params)
      end

      def close(user_id)
        MangoPay.request(:delete, url(user_id))
      end
    end
  end
end
