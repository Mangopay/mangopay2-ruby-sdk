describe MangoPay::PayIn::Payconiq::Web, type: :feature do
  include_context 'payins'

  def check_type_and_status(payin)
    expect(payin['Type']).to eq('PAYIN')
    expect(payin['Nature']).to eq('REGULAR')
    expect(payin['PaymentType']).to eq('PAYCONIQ')
    expect(payin['ExecutionType']).to eq('WEB')

    # not SUCCEEDED yet: waiting for processing
    expect(payin['Status']).to eq('CREATED')
    expect(payin['ResultCode']).to be_nil
    expect(payin['ResultMessage']).to be_nil
    expect(payin['ExecutionDate']).to be_nil
  end

  describe 'CREATE' do
    it 'creates a payconiq web payin' do
      created = new_payin_payconiq_web
      expect(created['Id']).not_to be_nil
      check_type_and_status(created)
    end

    it 'creates a payconiq web payin using the old endpoint' do
      created = new_payin_payconiq_web_legacy
      expect(created['Id']).not_to be_nil
      check_type_and_status(created)
    end
  end

end
