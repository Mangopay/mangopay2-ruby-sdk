module MangoPay

  class IdentityVerification < Resource
    def self.create(params, user_id, idempotency_key = nil)
      MangoPay.request(:post, "#{MangoPay.api_path}/users/#{user_id}/identity-verifications", params, {}, idempotency_key)
    end

    def self.get(identity_verification_id, filters = {})
      MangoPay.request(:get, "#{MangoPay.api_path}/identity-verifications/#{identity_verification_id}", {}, filters)
    end

    def self.get_all(user_id, filters = {})
      MangoPay.request(:get, "#{MangoPay.api_path}/users/#{user_id}/identity-verifications", {}, filters)
    end
  end
end
