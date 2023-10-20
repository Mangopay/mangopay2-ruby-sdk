describe MangoPay::Transfer, type: :feature do
  include_context 'wallets'
  include_context 'payins'
  include_context 'transfers'

  def check_type_and_status(trans)
    expect(trans['Type']).to eq('TRANSFER')
    expect(trans['Nature']).to eq('REGULAR')

    # SUCCEEDED
    expect(trans['Status']).to eq('SUCCEEDED')
    expect(trans['ResultCode']).to eq('000000')
    expect(trans['ResultMessage']).to eq('Success')
    expect(trans['ExecutionDate']).to be > 0
  end

  describe 'CREATE' do
    it 'creates a new Transfer' do
      created = new_transfer
      expect(created['Id']).not_to be_nil
      check_type_and_status(created)
    end
  end

  describe 'FETCH' do
    it 'fetches a Transfer' do
      created = new_transfer
      fetched = MangoPay::Transfer.fetch(created['Id'])
      expect(fetched['Id']).to eq(created['Id'])
      check_type_and_status(created)
      check_type_and_status(fetched)
    end
  end

  describe 'REFUND' do
    it 'refunds a transfer' do
      trans = new_transfer
      refund = MangoPay::Transfer.refund(trans['Id'], {AuthorId: trans['AuthorId']})
      expect(refund['Id']).not_to be_nil
      expect(refund['Status']).to eq('SUCCEEDED')
      expect(refund['Type']).to eq('TRANSFER')
      expect(refund['Nature']).to eq('REFUND')
      expect(refund['InitialTransactionType']).to eq('TRANSFER')
      expect(refund['InitialTransactionId']).to eq(trans['Id'])
      expect(refund['DebitedWalletId']).to eq(trans['CreditedWalletId'])
      expect(refund['CreditedWalletId']).to eq(trans['DebitedWalletId'])
    end
  end

  describe 'CASH FLOW' do
    it 'changes balances correctly' do
      wlt1 = new_wallet
      wlt2 = new_wallet_legal
      wallets_check_amounts(wlt1, 0, wlt2, 0)

      # payin: feed wlt1 with money
      create_new_payin_card_direct(wlt1, 1000)
      wallets_reload_and_check_amounts(wlt1, 1000, wlt2, 0)

      # transfer wlt1 => wlt2
      trans = create_new_transfer(wlt1, wlt2, 600)
      wallets_reload_and_check_amounts(wlt1, 400, wlt2, 600)

      # refund the transfer
      refund = MangoPay::Transfer.refund(trans['Id'], {AuthorId: trans['AuthorId']})
      wallets_reload_and_check_amounts(wlt1, 1000, wlt2, 0)
    end

    context 'when snakify_response_keys is true' do
      include_context 'snakify_response_keys'
      it 'changes balances correctly' do
        wlt1 = new_wallet2
        wlt2 = new_wallet_legal2
        wallets_check_amounts2(wlt1, 0, wlt2, 0)

        # payin: feed wlt1 with money
        create_new_payin_card_direct2(wlt1, 1000)
        wallets_reload_and_check_amounts2(wlt1, 1000, wlt2, 0)

        # transfer wlt1 => wlt2
        trans = create_new_transfer2(wlt1, wlt2, 600)
        wallets_reload_and_check_amounts2(wlt1, 400, wlt2, 600)

        # refund the transfer
        MangoPay::Transfer.refund(trans['id'], {AuthorId: trans['author_id']})
        wallets_reload_and_check_amounts2(wlt1, 1000, wlt2, 0)
      end
    end
  end

  describe 'FETCH Refunds' do
    it "fetches a transfer's refunds" do
      transfer = new_transfer
      refunds = MangoPay::Transfer.refunds(transfer['Id'])
      expect(refunds).to be_an(Array)
    end
  end
end
