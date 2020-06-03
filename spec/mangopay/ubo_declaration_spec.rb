describe MangoPay::UboDeclaration do
  include_context 'users'
  include_context 'ubo'

  describe 'FETCH' do
    it 'can fetch a UBO declaration' do
      legal_user = new_legal_user

      ubo_declaration = MangoPay::UboDeclaration.create(legal_user['Id'])

      ubo_declaration_byId = MangoPay::UboDeclaration.fetch(legal_user['Id'], ubo_declaration['Id'])

      expect(ubo_declaration).not_to be_nil
      expect(ubo_declaration_byId).not_to be_nil
    end

    describe 'UPDATE' do
      it 'can update a UBO declaration' do
        legal_user = new_legal_user
        ubo_declaration = MangoPay::UboDeclaration.create(legal_user['Id'])
        ubo_declaration['Status'] = 'VALIDATION_ASKED'

        ubo = new_ubo(legal_user, ubo_declaration)

        ubo_declaration['Ubos'] = [ubo]
        ubo_declaration = MangoPay::UboDeclaration.update(legal_user['Id'], ubo_declaration['Id'], ubo_declaration)

        expect(ubo_declaration).not_to be_nil
        expect(ubo_declaration['Status']).to eq 'VALIDATION_ASKED'
      end
    end
  end
end
