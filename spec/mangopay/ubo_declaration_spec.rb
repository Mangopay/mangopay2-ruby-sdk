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

    it 'fetches ubo declaration just by id' do
      legal_user = new_legal_user

      ubo_declaration = MangoPay::UboDeclaration.create(legal_user['Id'], nil)

      ubo_declaration_byId = MangoPay::UboDeclaration.fetch(nil, ubo_declaration['Id'], nil)

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

      context 'when snakify_response_keys is true' do
        include_context 'snakify_response_keys'
        it 'can update a UBO declaration' do
          legal_user = new_legal_user
          ubo_declaration = MangoPay::UboDeclaration.create(legal_user['id'])
          ubo_declaration['status'] = 'VALIDATION_ASKED'

          ubo = new_ubo2(legal_user, ubo_declaration)

          ubo_declaration['ubos'] = [ubo]
          ubo_declaration = MangoPay::UboDeclaration.update(legal_user['id'], ubo_declaration['id'], ubo_declaration)

          expect(ubo_declaration).not_to be_nil
          expect(ubo_declaration['status']).to eq 'VALIDATION_ASKED'
        end

        it 'returns error when parameters are wrong' do
          expect { MangoPay::UboDeclaration.update(nil , nil) }.to raise_error { |err|
            expect(err).to be_a MangoPay::ResponseError
            expect(err.code).to eq '404'
            expect(err.type).to be_nil
          }
        end
      end
    end
  end
end
