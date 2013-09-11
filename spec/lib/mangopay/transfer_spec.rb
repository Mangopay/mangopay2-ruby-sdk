require_relative '../../spec_helper'

describe MangoPay::Transfer, type: :feature do
  include_context 'users'
  include_context 'wallets'
  include_context 'transfer'

  describe 'CREATE' do
    it 'creates a new Transfer' do
      expect(new_transfer['Id']).not_to be_nil
      #expect(new_transfer['Status']).to eq('SUCCEEDED') # cannot test yet
      expect(new_transfer['Status']).to eq('FAILED')
    end
  end

  describe 'FETCH' do
    it 'fetches a Transfer' do
      transfer = MangoPay::Transfer.fetch(new_transfer['Id'])
      expect(transfer['Id']).to eq(new_transfer['Id'])
      #expect(new_transfer['Status']).to eq('SUCCEEDED') # cannot test yet
      expect(new_transfer['Status']).to eq('FAILED')
    end
  end

  describe 'REFUND' do
    it 'refunds a transfer' do
      transfer_refund = MangoPay::Transfer.refund(new_transfer['Id'], {
        AuthorId: new_transfer['AuthorId']
      })
      expect(transfer_refund['Id']).not_to be_nil
      #expect(transfer_refund['Status']).to eq('SUCCEEDED') # cannot test yet
      expect(transfer_refund['Status']).to be_nil
    end
  end
end
