describe MangoPay::PayIn::GooglePay::Direct, type: :feature do
  include_context 'payins'

  def check_type_and_status(payin)
    expect(payin['Type']).to eq('PAYIN')
    expect(payin['Nature']).to eq('REGULAR')
    expect(payin['PaymentType']).to eq('GOOGLE_PAY')
    expect(payin['ExecutionType']).to eq('DIRECT')
    expect(payin['Status']).to eq('CREATED')
  end

  describe 'CREATE' do
    it 'creates a googlepay direct payin' do
      pending("Cannot be tested due to impossibility to generate payment_data in test")
      created = new_payin_googlepay_direct
      expect(created['Id']).not_to be_nil
      check_type_and_status(created)
    end
  end
end

