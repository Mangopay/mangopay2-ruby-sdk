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

      # Create a UBO declaration.
      # @param +user_id+ ID of the legal user owning the declaration
      # @param +ubo_declaration+ Object containing UBO declaration data
      # @return Newly-created UBO declaration entity data
      def create_ubo_declaration(user_id, ubo_declaration)
        MangoPay.request(:post, "#{url(user_id)}/ubodeclarations", ubo_declaration)
      end
    end
  end
end
