require 'securerandom'

describe MangoPay::Response do
  include_context 'users'

  describe 'FETCH' do
    it 'fetches a response' do
      idempotency_key = SecureRandom.uuid
      request = MangoPay::NaturalUserSca.create(define_new_natural_user_sca_payer, nil, idempotency_key)
      response = MangoPay::Response.fetch(idempotency_key)


      expect(response['RequestURL']).not_to be_nil
      expect(response['Resource']).not_to be_nil
    end
  end
end
