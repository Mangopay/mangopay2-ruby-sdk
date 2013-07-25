require_relative '../../spec_helper'

describe MangoPay::Wallet do

  let(:new_natural_user) {
    MangoPay::NaturalUser.create({
      Tag: 'test',
      Email: 'my@email.com',
      FirstName: 'John',
      LastName: 'Doe',
      Address: 'Here',
      Birthday: '',
      Birthplace: 'Paris',
      Nationality: 'FR',
      CountryOfResidence: 'FR',
      Occupation: 'Worker',
      IncomeRange: 1
    })
  }

  let(:new_wallet) {
    MangoPay::Wallet.create({
      Owners: [new_natural_user['Id']],
      Description: 'A test wallet',
      Currency: 'EUR',
      Tag: 'Test Time'
    })
  }

  describe 'CREATE' do
    it 'creates a wallet' do
      expect(new_wallet['Id']).to_not be_nil
      expect(new_wallet['Balance']['Currency']).to eq('EUR')
      expect(new_wallet['Balance']['Amount']).to eq(0)
    end
  end

  describe 'UPDATE' do
    it 'updates a wallet' do
      updated_wallet = MangoPay::Wallet.update(new_wallet['Id'], {
        Description: 'Updated Description',
        Tag: 'Updated Tag'
      })
      expect(updated_wallet['Description']).to eq('Updated Description')
      expect(updated_wallet['Tag']).to eq('Updated Tag')
    end
  end

  describe 'FETCH' do
    it 'fetches a wallet' do
      wallet = MangoPay::Wallet.fetch(new_wallet['Id'])
      expect(wallet['Id']).to eq(new_wallet['Id'])
    end
  end
end
