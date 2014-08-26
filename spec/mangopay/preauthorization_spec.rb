describe MangoPay::PreAuthorization do
  include_context 'users'
  include_context 'payins'

  describe 'CREATE' do
    it 'creates a new card pre-authorization' do
      cardreg = new_card_registration_completed
      created = new_card_preauthorization
      expect(created['Id']).not_to be_nil
      expect(created['Id'].to_i).to be > 0
      expect(created['CardId']).to eq(cardreg['CardId'])
      expect(created['AuthorId']).to eq(new_natural_user["Id"])
      expect(created['PayInId']).to be_nil
      expect(created['Status']).to eq('SUCCEEDED')
      expect(created['PaymentStatus']).to eq('WAITING')
      expect(created['PaymentType']).to eq('CARD')
      expect(created['ExecutionType']).to eq('DIRECT')
    end
  end

  describe 'UPDATE' do
    it 'updates a card pre-authorization' do
      created = new_card_preauthorization
      updated = MangoPay::PreAuthorization.update(created['Id'] ,{
        PaymentStatus: 'CANCELED'
      })
      expect(updated['PaymentStatus']).to eq('CANCELED')
    end
  end

  describe 'FETCH' do
    it 'fetches a card pre-authorization' do
      created = new_card_preauthorization
      fetched = MangoPay::PreAuthorization.fetch(created['Id'])
      expect(fetched['Id']).to eq(created['Id'])
      expect(fetched['CardId']).to eq(created['CardId'])
      expect(fetched['AuthorId']).to eq(created['AuthorId'])
      expect(fetched['Tag']).to eq(created['Tag'])
    end
  end

end
