describe MangoPay::Ubo do
  include_context 'users'
  include_context 'ubo'

  describe 'FETCH' do
    it 'can fetch a Ubo' do
      legal_user = new_legal_user
      ubo_declaration = MangoPay::UboDeclaration.create(legal_user['Id'], nil)
      ubo = new_ubo(legal_user, ubo_declaration)
      result = MangoPay::Ubo.fetch(legal_user['Id'], ubo_declaration['Id'], ubo['Id'])
      expect(result).not_to be_nil
      expect(result['Id']).equal? ubo['Id']
    end
  end

  describe 'CREATE' do
    it 'can create a new Ubo' do
      legal_user = new_legal_user
      ubo_declaration = MangoPay::UboDeclaration.create(legal_user['Id'], nil)
      result = new_ubo(legal_user, ubo_declaration)
      expect(result).not_to be_nil
    end
  end

  describe 'UPDATE' do
    it 'can update a Ubo' do
      legal_user = new_legal_user
      ubo_declaration = MangoPay::UboDeclaration.create(legal_user['Id'], nil)
      ubo = new_ubo(legal_user, ubo_declaration)
      ubo['FirstName'] = 'Santa'
      ubo['LastName'] = 'Clause'

      result = MangoPay::Ubo.update(legal_user['Id'], ubo_declaration['Id'], ubo['Id'], ubo)
      expect(result).not_to be_nil
      expect(result['FirstName']).equal? ubo['FirstName']
      expect(result['LastName']).equal? ubo['LastName']
    end
  end
end
