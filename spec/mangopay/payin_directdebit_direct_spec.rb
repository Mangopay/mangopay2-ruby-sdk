describe MangoPay::PayIn::DirectDebit::Direct, type: :feature do
  include_context 'payins'

  def check_type_and_status(payin)
    expect(payin['Type']).to eq('PAYIN')
    expect(payin['Nature']).to eq('REGULAR')
    expect(payin['PaymentType']).to eq('DIRECT_DEBIT')
    expect(payin['ExecutionType']).to eq('DIRECT')

    # FAILED: the related Mandate is not confirmed yet
    expect(payin['Status']).to eq('FAILED')
    expect(payin['ResultMessage']).to eq('The Status of this Mandate does not allow for payments')
    expect(payin['ExecutionDate']).to be_nil
  end
  
  describe 'CREATE' do
    it 'creates a directdebit direct payin' do
      created = new_payin_directdebit_direct
      expect(created['Id']).not_to be_nil
      check_type_and_status(created)
    end
  end

  describe 'FETCH' do
    it 'fetches a payin' do
      created = new_payin_directdebit_direct
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
