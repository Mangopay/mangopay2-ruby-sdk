require_relative '../../spec_helper'

describe MangoPay::Refund do
  include_context 'transfers'

  describe 'FETCH' do
    it 'fetches a refund' do
      transfer = new_transfer
      resource = MangoPay::Transfer.refund(transfer['Id'], { AuthorId: transfer['AuthorId'] })

      refund = MangoPay::Refund.fetch(resource['Id'])

      expect(refund['Id']).not_to be_nil
      expect(refund['Status']).to eq('SUCCEEDED')
      expect(refund['Type']).to eq('TRANSFER')
      expect(refund['Nature']).to eq('REFUND')
      expect(refund['InitialTransactionType']).to eq('TRANSFER')
      expect(refund['InitialTransactionId']).to eq(transfer['Id'])
      expect(refund['DebitedWalletId']).to eq(transfer['CreditedWalletId'])
      expect(refund['CreditedWalletId']).to eq(transfer['DebitedWalletId'])
    end
  end
end
