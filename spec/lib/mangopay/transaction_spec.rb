require_relative '../../spec_helper'

describe MangoPay::Transaction do
  include_context 'wallets'
  include_context 'payins'
  include_context 'payouts'

  describe 'FETCH' do

    it 'fetches empty list of transactions if no transactions done' do
      transactions = MangoPay::Transaction.fetch(new_wallet['Id'])
      expect(transactions).to be_kind_of(Array)
      expect(transactions).to be_empty
    end

    it 'fetches list with single transaction after payin done' do
      payin = new_payin_card_direct
      transactions = MangoPay::Transaction.fetch(new_wallet['Id'])
      expect(transactions).to be_kind_of(Array)
      expect(transactions.count).to eq 1
      expect(transactions[0]['Id']).to eq payin['Id']
    end

    it 'fetches list with two transactions after payin and payout done' do
      payin = new_payin_card_direct
      payout = create_new_payout_bankwire(payin)
      transactions = MangoPay::Transaction.fetch(new_wallet['Id'])
      expect(transactions).to be_kind_of(Array)
      expect(transactions.count).to eq 2
      expect(transactions[0]['Id']).to eq payout['Id'] # last on top, so payout is before payin
      expect(transactions[1]['Id']).to eq payin['Id']
    end

  end
end
