describe MangoPay::PayIn::PreAuthorized::Direct, type: :feature do
  include_context 'wallets'
  include_context 'payins'
  include_context 'users'

  def check_type_and_status(payin)
    expect(payin['Type']).to eq('PAYIN')
    expect(payin['Nature']).to eq('REGULAR')
    expect(payin['PaymentType']).to eq('PREAUTHORIZED')
    expect(payin['ExecutionType']).to eq('DIRECT')

    # SUCCEEDED
    expect(payin['Status']).to eq('SUCCEEDED')
    expect(payin['ResultCode']).to eq('000000')
    expect(payin['ResultMessage']).to eq('Success')
    expect(payin['ExecutionDate']).to be > 0
  end

  describe 'CREATE' do
    it 'creates a preauthorized direct payin' do
      created = new_payin_preauthorized_direct
      # wait for the transactions to be created
      sleep(2)
      transactions = MangoPay::PreAuthorization.transactions(created['PreauthorizationId'])
      expect(created['Id']).not_to be_nil
      expect(transactions[0]['Status']).to eq('SUCCEEDED')
      check_type_and_status(created)
    end
  end

  describe 'FETCH' do
    it 'fetches a payin' do
      created = new_payin_preauthorized_direct
      fetched = MangoPay::PayIn.fetch(created['Id'])
      expect(fetched['Id']).to eq(created['Id'])
      expect(fetched['CreationDate']).to eq(created['CreationDate'])
      expect(fetched['CreditedFunds']).to eq(created['CreditedFunds'])
      expect(fetched['CreditedWalletId']).to eq(created['CreditedWalletId'])
      check_type_and_status(created)
      check_type_and_status(fetched)
    end
  end

  describe 'REFUND' do
    it 'refunds a payin' do
      payin = new_payin_preauthorized_direct
      sleep(2)
      refund = MangoPay::PayIn.refund(payin['Id'], {AuthorId: payin['AuthorId']})
      expect(refund['Id']).not_to be_nil
      expect(refund['Status']).to eq('SUCCEEDED')
      expect(refund['Type']).to eq('PAYOUT')
      expect(refund['Nature']).to eq('REFUND')
      expect(refund['InitialTransactionType']).to eq('PAYIN')
      expect(refund['InitialTransactionId']).to eq(payin['Id'])
      expect(refund['DebitedWalletId']).to eq(payin['CreditedWalletId'])
    end
  end

  describe 'CASH FLOW' do
    it 'changes balances correctly' do
      wlt = new_wallet
      wallets_check_amounts(wlt, 0)

      # payin: feed wlt1 with money
      payin = create_new_payin_preauthorized_direct(wlt, 1000)
      wallets_reload_and_check_amounts(wlt, 1000)

      # refund the payin
      refund = MangoPay::PayIn.refund(payin['Id'], {AuthorId: payin['AuthorId']})
      wallets_reload_and_check_amounts(wlt, 0)
    end
  end

    # this flow is tested manually for the moment
=begin
  describe 'CREATE AND VIEW PRE AUTHORIZED DEPOSIT' do
    it 'creates a card direct pre authorized deposit payin' do
      wallet = new_wallet
      author = new_natural_user
      card_registration = new_card_registration_completed
      deposit = create_new_deposit(card_registration['CardId'], author['Id'])

      created = create_new_payin_pre_authorized_deposit_direct(deposit['Id'], author['Id'], wallet['Id'])

      expect(created['Id']).not_to be_nil
      check_type_and_status(created)
      expect(created['DepositId']).to eq(deposit['Id'])
    end
  end
=end
end
