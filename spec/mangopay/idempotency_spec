describe MangoPay do

  # see https://docs.mangopay.com/api-references/idempotency-support/

  include_context 'users'
  require 'securerandom'

  describe 'post requests' do

    it 'if called with no idempotency key, act independently' do
      u = define_new_natural_user
      u1 = MangoPay::NaturalUser.create(u)
      u2 = MangoPay::NaturalUser.create(u)
      expect(u2['Id']).to be > u1['Id']
    end

    it 'if called with same idempotency key, the 2nd call is blocked' do
      idempotency_key = SecureRandom.uuid
      u = define_new_natural_user
      u1 = MangoPay::NaturalUser.create(u, nil, idempotency_key)
      expect {
        u2 = MangoPay::NaturalUser.create(u, nil, idempotency_key)
      }.to raise_error(MangoPay::ResponseError)
    end

    it 'if called with different idempotency key, act independently and responses may be retreived later' do
      idempotency_key1 = SecureRandom.uuid
      idempotency_key2 = SecureRandom.uuid
      u = define_new_natural_user
      u1 = MangoPay::NaturalUser.create(u, nil, idempotency_key1)
      u2 = MangoPay::NaturalUser.create(u, nil, idempotency_key2)
      expect(u2['Id']).to be > u1['Id']

      resp1 = MangoPay.fetch_response(idempotency_key1)
      resp2 = MangoPay.fetch_response(idempotency_key2)
      expect(resp1['Resource']['Id']).to eq u1['Id']
      expect(resp2['Resource']['Id']).to eq u2['Id']
    end

  end
end
