describe MangoPay::PayIn::Mbway::Direct, type: :feature do
  include_context 'wallets'
  include_context 'payins'
  
  def check_type_and_status(payin)
    expect(payin['Type']).to eq('PAYIN')
    expect(payin['Nature']).to eq('REGULAR')
    expect(payin['PaymentType']).to eq('MBWAY')
    expect(payin['ExecutionType']).to eq('DIRECT')
    expect(payin['Status']).to eq('CREATED')
  end

  describe 'CREATE' do
    it 'creates a mbway direct payin' do
      created = new_payin_mbway_direct
      expect(created['Id']).not_to be_nil
      expect(created['PhoneNumber']).not_to be_nil
      check_type_and_status(created)
    end
  end

  describe 'FETCH' do
    it 'fetches a payin' do
      created = new_payin_mbway_direct
      fetched = MangoPay::PayIn.fetch(created['Id'])
      expect(fetched['Id']).to eq(created['Id'])
      check_type_and_status(created)
      check_type_and_status(fetched)
    end
  end

end
