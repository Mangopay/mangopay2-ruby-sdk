describe MangoPay::PayIn::BankWire::ExternalInstruction, type: :feature do
  include_context 'wallets'
  include_context 'payins'
  
  def check_type_and_status(payin)
    expect(payin['Type']).to eq('PAYIN')
    expect(payin['Nature']).to eq('REGULAR')
    expect(payin['PaymentType']).to eq('BANK_WIRE')
    expect(payin['ExecutionType']).to eq('EXTERNAL_INSTRUCTION')
  end

  describe 'FETCH' do
    it 'fetches a payin' do
      MangoPay.configure do |c|
        c.preproduction = true
        c.client_id = 'sdk-unit-tests'   
        c.root_url = 'https://api-sandbox.mangopay.com'
        c.client_apiKey = 'cqFfFrWfCcb7UadHNxx2C9Lo6Djw8ZduLi7J9USTmu8bhxxpju'
        c.http_timeout = 10000
      end

      id = "2826947"
      payIn = MangoPay::PayIn.fetch(id)
      expect(payIn['Id']).to eq(id)
      check_type_and_status(payIn)
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
