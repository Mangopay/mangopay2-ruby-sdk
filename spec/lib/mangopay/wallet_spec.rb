require_relative '../../spec_helper'

describe MangoPay::Wallet do
  include_context 'wallets'

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
