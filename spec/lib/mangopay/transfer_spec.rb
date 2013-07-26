require_relative '../../spec_helper'

describe MangoPay::Transfer, type: :feature do
  include_context 'users'
  include_context 'wallets'
  include_context 'transfer'

  describe 'CREATE' do
    it 'creates a new Transfer' do
      expect(new_transfer['Id']).not_to be_nil
      expect(new_transfer['Status']).to eq('SUCCEEDED')
    end
  end

  describe 'FETCH' do
    it 'fetches a Transfer' do
      transfer = MangoPay::Transfer.fetch(new_transfer['Id'])
      expect(transfer['Id']).to eq(new_transfer['Id'])
      expect(new_transfer['Status']).to eq('SUCCEEDED')
    end
  end
end
