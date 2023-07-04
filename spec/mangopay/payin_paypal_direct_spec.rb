describe MangoPay::PayIn::PayPal::Direct, type: :feature do
  include_context 'payins'

  def check_type_and_status(payin)
    expect(payin['Type']).to eq('PAYIN')
    expect(payin['Nature']).to eq('REGULAR')
    expect(payin['PaymentType']).to eq('PAYPAL')
    expect(payin['ExecutionType']).to eq('DIRECT')

    # not SUCCEEDED yet: waiting for processing
    expect(payin['Status']).to eq('CREATED')
    expect(payin['ResultCode']).to be_nil
    expect(payin['ResultMessage']).to be_nil
    expect(payin['ExecutionDate']).to be_nil
  end

  describe 'CREATE' do
    it 'creates a paypal direct payin' do
      created = new_payin_paypal_direct
      expect(created['Id']).not_to be_nil
      check_type_and_status(created)
    end
  end

  describe 'FETCH' do
    it 'fetches a payin' do
      created = new_payin_paypal_direct
      fetched = MangoPay::PayIn.fetch(created['Id'])
      expect(fetched['Id']).to eq(created['Id'])
      expect(fetched['CreationDate']).to eq(created['CreationDate'])
      expect(fetched['CreditedFunds']).to eq(created['CreditedFunds'])
      expect(fetched['CreditedWalletId']).to eq(created['CreditedWalletId'])
      check_type_and_status(created)
      check_type_and_status(fetched)
    end
  end

end
