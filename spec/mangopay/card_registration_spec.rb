describe MangoPay::CardRegistration do
  include_context 'users'
  include_context 'payins'

  describe 'CREATE' do
    it 'creates a new card registration' do
      created = new_card_registration
      expect(created['Id']).not_to be_nil
      expect(created['Id'].to_i).to be > 0
      expect(created['AccessKey']).not_to be_nil
      expect(created['PreregistrationData']).not_to be_nil
      expect(created['CardRegistrationURL']).not_to be_nil
      expect(created['RegistrationData']).to be_nil
      expect(created['CardId']).to be_nil
      expect(created['UserId']).to eq(new_natural_user["Id"])
      expect(created['Currency']).to eq('EUR')
      expect(created['Status']).to eq('CREATED')
    end
  end

  describe 'UPDATE' do
    it 'updates a card registration' do
      created = new_card_registration
      updated = MangoPay::CardRegistration.update(created['Id'] ,{
        RegistrationData: 'test RegistrationData'
      })
      expect(updated['RegistrationData']).to eq('test RegistrationData')
    end
  end

  describe 'FETCH' do
    it 'fetches a card registration' do
      created = new_card_registration
      fetched = MangoPay::CardRegistration.fetch(created['Id'])
      expect(fetched['Id']).to eq(created['Id'])
      expect(fetched['UserId']).to eq(created['UserId'])
      expect(fetched['Tag']).to eq(created['Tag'])
    end
  end

  describe 'TOKENIZATION PROCESS' do
    it 'fills-in registration data and links it to a newly created card' do
      completed = new_card_registration_completed
      reg_data = completed['RegistrationData']
      card_id = completed['CardId']

      # reg data filled-in
      expect(reg_data).not_to be_nil
      expect(reg_data).to be_kind_of String
      expect(reg_data).not_to be_empty

      # card id filled-in...
      expect(card_id).not_to be_nil
      expect(card_id.to_i).to be > 0

      # ...and points to existing (newly created) card
      card = MangoPay::Card.fetch(card_id)
      expect(card['Id']).to eq card_id

################################################################################
# cannot test updating: one can only put a CARD from "VALID" to "INVALID"
#      # let's test updating the card too
#      expect(card['Validity']).to eq 'UNKNOWN'
#      card_updated = MangoPay::Card.update(card_id ,{
#        Validity: 'INVALID'
#      })
#      expect(card_updated['Validity']).to eq 'INVALID'
#      expect(MangoPay::Card.fetch(card_id)['Validity']).to eq 'INVALID'
################################################################################
    end

    describe '.get_by_fingerprint' do
      it 'retrieves list of cards having same fingerprint' do
        completed = new_card_registration_completed
        card_id = completed['CardId']
        card = MangoPay::Card.fetch(card_id)
        fingerprint = card['Fingerprint']
        result = MangoPay::Card.get_by_fingerprint(fingerprint)

        expect(result).to be_kind_of(Array)
        result.each do |card|
          expect(card['Fingerprint']).to eq fingerprint
        end
      end
    end
  end

  describe 'FETCH Transactions' do
    it "retrieves list of card's transactions" do
      card_id = new_card_registration_completed['CardId']
      transactions = MangoPay::Card.transactions(card_id)
      expect(transactions).to be_an(Array)
    end
  end
end
