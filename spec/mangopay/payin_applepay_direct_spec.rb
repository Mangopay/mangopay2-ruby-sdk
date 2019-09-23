describe MangoPay::PayIn::ApplePay::Direct, type: :feature do
  include_context 'payins'

  def check_type_and_status(payin)
    expect(payin['Type']).to eq('PAYIN')
    expect(payin['Nature']).to eq('REGULAR')
    expect(payin['PaymentType']).to eq('APPLEPAY')
    expect(payin['ExecutionType']).to eq('DIRECT')
    expect(payin['Status']).to eq('SUCCEEDED')
  end

  describe 'CREATE' do
    it 'creates a applepay direct payin' do
      created = new_payin_applepay_direct
      expect(created['Id']).not_to be_nil
      check_type_and_status(created)
    end
  end
end

