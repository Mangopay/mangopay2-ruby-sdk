module MangoPay

  class IdentityVerification < Resource
    def self.create(params, user_id, idempotency_key = nil)
      MangoPay.request(:post, "#{MangoPay.api_path}/users/#{user_id}/identity-verifications", params, {}, idempotency_key)
    end
  end
end
