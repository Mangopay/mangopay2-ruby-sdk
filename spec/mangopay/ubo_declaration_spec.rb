describe MangoPay::UboDeclaration do
  include_context 'users'

  describe 'FETCH' do
    it 'can fetch a UBO declaration' do
      legal_user = new_legal_user
      natural_user = define_new_natural_user
      natural_user['Capacity'] = 'DECLARATIVE'
      natural_user = MangoPay::NaturalUser.create(natural_user)
      ubo_declaration = {
        DeclaredUBOs: [natural_user['Id']]
      }
      ubo_declaration = MangoPay::LegalUser.create_ubo_declaration(legal_user['Id'], ubo_declaration)
      ubo_declaration = MangoPay::UboDeclaration.fetch(ubo_declaration['Id'])

      expect(ubo_declaration).not_to be_nil
    end

    describe 'UPDATE' do
      it 'can update a UBO declaration' do
        legal_user = new_legal_user
        natural_user = define_new_natural_user
        natural_user['Capacity'] = 'DECLARATIVE'
        natural_user = MangoPay::NaturalUser.create(natural_user)
        ubo_declaration = {
          DeclaredUBOs: [natural_user['Id']]
        }
        ubo_declaration = MangoPay::LegalUser.create_ubo_declaration(legal_user['Id'], ubo_declaration)
        ubo_declaration['Status'] = 'VALIDATION_ASKED'
        ubo_declaration = MangoPay::UboDeclaration.update(ubo_declaration['Id'], ubo_declaration)

        expect(ubo_declaration).not_to be_nil
        expect(ubo_declaration['Status']).to eq 'VALIDATION_ASKED'
      end
    end
  end
end