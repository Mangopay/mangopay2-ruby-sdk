describe MangoPay::Ubo do
  include_context 'users'
  include_context 'ubo'

  let(:legal_user) { new_legal_user }
  let(:ubo_declaration) { MangoPay::UboDeclaration.create(legal_user['Id']) }
  let(:ubo) { new_ubo(legal_user, ubo_declaration) }

  describe 'FETCH' do
    it 'can fetch a Ubo' do
      result = MangoPay::Ubo.fetch(legal_user['Id'], ubo_declaration['Id'], ubo['Id'])
      expect(result).not_to be_nil
      expect(result['Id']).equal? ubo['Id']
    end
  end

  describe 'CREATE' do
    it 'can create a new Ubo' do
      result = new_ubo(legal_user, ubo_declaration)
      expect(result).not_to be_nil
    end

    it 'returns error if trying to create a second ubo for the same user' do
      MangoPay::UboDeclaration.create(legal_user['Id'])

      expect { MangoPay::UboDeclaration.create(legal_user['Id']) }.to raise_error { |err|
        expect(err).to be_a MangoPay::ResponseError
        expect(err.code).to eq '400'
        expect(err.type).to eq 'invalid_action'
        expect(err.message).to eq 'You can not create a declaration because you already have a declaration in progress'
      }
    end
  end

  describe 'UPDATE' do
    it 'can update a Ubo' do
      ubo['FirstName'] = 'Santa'
      ubo['LastName'] = 'Clause'

      result = MangoPay::Ubo.update(legal_user['Id'], ubo_declaration['Id'], ubo['Id'], ubo)
      expect(result).not_to be_nil
      expect(result['FirstName']).equal? ubo['FirstName']
      expect(result['LastName']).equal? ubo['LastName']
    end

    context 'when snakify_response_keys is true' do
      include_context 'snakify_response_keys'
      it 'can update a Ubo' do
        ubo_declaration = MangoPay::UboDeclaration.create(legal_user['id'])
        ubo = new_ubo2(legal_user, ubo_declaration)
        ubo['first_name'] = 'Santa'
        ubo['last_name'] = 'Clause'

        camel_case_ubo = MangoPay.camelize_keys(ubo)

        result = MangoPay::Ubo.update(legal_user['id'], ubo_declaration['id'], camel_case_ubo['Id'], camel_case_ubo)
        expect(result).not_to be_nil
        expect(result['first_name']).equal? ubo['first_name']
        expect(result['last_name']).equal? ubo['last_name']
      end
    end
  end
end
