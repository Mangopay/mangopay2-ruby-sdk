describe MangoPay::Wallet do
  include_context 'wallets'
  include_context 'payins'
  include_context 'payouts'

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

    it 'fetches a wallet sca' do
      begin
        MangoPay::Wallet.fetch(new_wallet['Id'], nil, {'ScaContext': 'USER_PRESENT'})
      rescue MangoPay::ResponseError => ex
        expect(ex.details['RedirectUrl']).not_to be_nil
      end
    end
  end

  describe 'FETCH TRANSACTIONS' do

    it 'fetches empty list of transactions if no transactions done' do
      transactions = MangoPay::Wallet.transactions(new_wallet['Id'])
      expect(transactions).to be_kind_of(Array)
      expect(transactions).to be_empty
    end

    it 'fetches list with single transaction after payin done' do
      payin = new_payin_card_direct
      transactions = MangoPay::Wallet.transactions(new_wallet['Id'])
      expect(transactions).to be_kind_of(Array)
      expect(transactions.count).to eq 1
      expect(transactions.first['Id']).to eq payin['Id']
    end

    it 'fetches list with two transactions after payin and payout done' do
      payin = new_payin_card_direct
      payout = create_new_payout_bankwire(payin)
      # wait for the transactions to be created
      sleep(2)
      transactions = MangoPay::Wallet.transactions(new_wallet['Id'])

      expect(transactions).to be_kind_of(Array)
      expect(transactions.count).to eq 2

      transactions_ids = transactions.map {|t| t['Id']}
      expect(transactions_ids).to include payin['Id']
      expect(transactions_ids).to include payout['Id']
    end

    it 'accepts filtering params' do
      payin = new_payin_card_direct
      payout = create_new_payout_bankwire(payin)
      wallet_id = new_wallet['Id']

      # wait for the transactions to be created
      sleep(2)

      by_nature_reg = MangoPay::Wallet.transactions(wallet_id, {'Nature' => 'REGULAR'})
      by_nature_ref = MangoPay::Wallet.transactions(wallet_id, {'Nature' => 'REFUND'})
      expect(by_nature_reg.count).to eq 2
      expect(by_nature_ref.count).to eq 0

      by_type_pyin  = MangoPay::Wallet.transactions(wallet_id, {'Type' => 'PAYIN'})
      by_type_pyout = MangoPay::Wallet.transactions(wallet_id, {'Type' => 'PAYOUT'})
      expect(by_type_pyin.count).to eq 1
      expect(by_type_pyout.count).to eq 1
      expect(by_type_pyin.first['Id']).to eq payin['Id']
      expect(by_type_pyout.first['Id']).to eq payout['Id']
    end

    it 'fetches transactions sca' do
      begin
        MangoPay::Wallet.transactions(new_wallet['Id'], {'ScaContext': 'USER_PRESENT'})
      rescue MangoPay::ResponseError => ex
        expect(ex.details['RedirectUrl']).not_to be_nil
      end
    end
  end
end
