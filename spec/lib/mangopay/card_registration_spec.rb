require_relative '../../spec_helper'

describe MangoPay::CardRegistration do
  include_context 'users'
  include_context 'card_registration'

  describe 'CREATE' do
    it 'creates a new card registration' do
      expect(new_card_registration['Id']).not_to be_nil
      expect(new_card_registration['Id'].to_i).to be > 0
      expect(new_card_registration['AccessKey']).not_to be_nil
      expect(new_card_registration['PreregistrationData']).not_to be_nil
      expect(new_card_registration['CardRegistrationURL']).not_to be_nil
      expect(new_card_registration['CardId']).to be_nil
      expect(new_card_registration['RegistrationData']).to be_nil
      expect(new_card_registration['UserId']).to eq(new_natural_user["Id"])
      expect(new_card_registration['Currency']).to eq('EUR')
      expect(new_card_registration['Status']).to eq('CREATED')
    end
  end

  describe 'UPDATE' do
    it 'updates a card registration' do
      updated = MangoPay::CardRegistration.update(new_card_registration['Id'] ,{
        RegistrationData: 'test RegistrationData'
      })
      expect(updated['RegistrationData']).to eq('test RegistrationData')
    end
  end

  describe 'FETCH' do
    it 'fetches a card registration' do
      fetched = MangoPay::CardRegistration.fetch(new_card_registration['Id'])
      expect(fetched['Id']).to eq(new_card_registration['Id'])
      expect(fetched['UserId']).to eq(new_card_registration['UserId'])
      expect(fetched['Tag']).to eq(new_card_registration['Tag'])
    end
  end

end
