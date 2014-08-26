describe MangoPay::PayIn::BankWire::Direct, type: :feature do
  include_context 'wallets'
  include_context 'payins'
  
  def check_type_and_status(payin)
    expect(payin['Type']).to eq('PAYIN')
    expect(payin['Nature']).to eq('REGULAR')
    expect(payin['PaymentType']).to eq('BANK_WIRE')
    expect(payin['ExecutionType']).to eq('DIRECT')

    expect(payin['Status']).to eq('CREATED')
    expect(payin['ResultCode']).to be_nil
    expect(payin['ResultMessage']).to be_nil
    expect(payin['ExecutionDate']).to be_nil
  end

  describe 'CREATE' do
    it 'creates a bankwire direct payin' do
      created = new_payin_bankwire_direct
      expect(created['Id']).not_to be_nil
      check_type_and_status(created)
    end
  end

  describe 'FETCH' do
    it 'fetches a payin' do
      created = new_payin_bankwire_direct
      fetched = MangoPay::PayIn.fetch(created['Id'])
      expect(fetched['Id']).to eq(created['Id'])
      expect(fetched['CreationDate']).to eq(created['CreationDate'])
      expect(fetched['DeclaredDebitedFunds']).to eq(created['DeclaredDebitedFunds'])
      expect(fetched['CreditedWalletId']).to eq(created['CreditedWalletId'])
      check_type_and_status(created)
      check_type_and_status(fetched)
    end
  end

###############################################
# refund not implemented for this type of payin
###############################################
#  describe 'REFUND' do
#    it 'refunds a payin' do
#      payin = new_payin_bankwire_direct
#      refund = MangoPay::PayIn.refund(payin['Id'], {AuthorId: payin['AuthorId']})
#      expect(refund['Id']).not_to be_nil
#      expect(refund['Status']).to eq('SUCCEEDED')
#      expect(refund['Type']).to eq('PAYOUT')
#      expect(refund['Nature']).to eq('REFUND')
#      expect(refund['InitialTransactionType']).to eq('PAYIN')
#      expect(refund['InitialTransactionId']).to eq(payin['Id'])
#      expect(refund['DebitedWalletId']).to eq(payin['CreditedWalletId'])
#    end
#  end
#
###############################################
# status is CREATED instead of SUCCEEDED
# so no cash flow yet
###############################################
#  describe 'CASH FLOW' do
#    it 'changes balances correctly' do
#      wlt = new_wallet
#      wallets_check_amounts(wlt, 0)
#
#      # payin: feed wlt1 with money
#      payin = create_new_payin_bankwire_direct(wlt, 1000)
#      wallets_reload_and_check_amounts(wlt, 1000)
#
#      # refund the payin
#      refund = MangoPay::PayIn.refund(payin['Id'], {AuthorId: payin['AuthorId']})
#      wallets_reload_and_check_amounts(wlt, 0)
#    end
#  end

end
