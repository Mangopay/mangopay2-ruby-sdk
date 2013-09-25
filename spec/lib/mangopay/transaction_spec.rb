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
      expect(transactions.first['Id']).to eq payin['Id']
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

    it 'accepts filtering params' do
      payin = new_payin_card_direct
      payout = create_new_payout_bankwire(payin)
      wallet_id = new_wallet['Id']

      by_nature_reg = MangoPay::Transaction.fetch(wallet_id, {'Nature' => 'REGULAR'})
      by_nature_ref = MangoPay::Transaction.fetch(wallet_id, {'Nature' => 'REFUND'})
      expect(by_nature_reg.count).to eq 2
      expect(by_nature_ref.count).to eq 0

      by_type_pyin  = MangoPay::Transaction.fetch(wallet_id, {'Type' => 'PAYIN'})
      by_type_pyout = MangoPay::Transaction.fetch(wallet_id, {'Type' => 'PAYOUT'})
      expect(by_type_pyin.count).to eq 1
      expect(by_type_pyout.count).to eq 1
      expect(by_type_pyin.first['Id']).to eq payin['Id']
      expect(by_type_pyout.first['Id']).to eq payout['Id']

      by_dir_cred = MangoPay::Transaction.fetch(wallet_id, {'Direction' => 'CREDIT'})
      by_dir_debt = MangoPay::Transaction.fetch(wallet_id, {'Direction' => 'DEBIT'})
      expect(by_dir_cred.count).to eq 1
      expect(by_dir_debt.count).to eq 1
      expect(by_dir_cred.first['Id']).to eq payin['Id']
      expect(by_dir_debt.first['Id']).to eq payout['Id']
    end

  end
end
