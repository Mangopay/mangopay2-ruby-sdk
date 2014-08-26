describe MangoPay::PayIn::Card::Web, type: :feature do
  include_context 'payins'

  def check_type_and_status(payin)
    expect(payin['Type']).to eq('PAYIN')
    expect(payin['Nature']).to eq('REGULAR')
    expect(payin['PaymentType']).to eq('CARD')
    expect(payin['ExecutionType']).to eq('WEB')

    # not SUCCEEDED yet: waiting for processing
    expect(payin['Status']).to eq('CREATED')
    expect(payin['ResultCode']).to be_nil
    expect(payin['ResultMessage']).to be_nil
    expect(payin['ExecutionDate']).to be_nil
  end
  
  describe 'CREATE' do
    it 'creates a card web payin' do
      created = new_payin_card_web
      expect(created['Id']).not_to be_nil
      check_type_and_status(created)
    end
  end

  describe 'FETCH' do
    it 'fetches a payin' do
      created = new_payin_card_web
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
      payin = new_payin_card_web
      refund = MangoPay::PayIn.refund(payin['Id'], {AuthorId: payin['AuthorId']})
      expect(refund['Id']).not_to be_nil
      expect(refund['Type']).to eq('PAYOUT')
      expect(refund['Nature']).to eq('REFUND')
      expect(refund['InitialTransactionType']).to eq('PAYIN')
      expect(refund['InitialTransactionId']).to eq(payin['Id'])
      expect(refund['DebitedWalletId']).to eq(payin['CreditedWalletId'])
      expect(refund['Status']).to eq('FAILED')
      expect(refund['ResultCode']).to eq('001001')
      expect(refund['ResultMessage']).to eq('Unsufficient wallet balance')
    end
  end

end
