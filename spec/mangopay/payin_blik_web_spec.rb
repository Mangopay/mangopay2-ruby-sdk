describe MangoPay::PayIn::Blik::Web, type: :feature do
  include_context 'wallets'
  include_context 'payins'
  
  def check_type_and_status(payin)
    expect(payin['Type']).to eq('PAYIN')
    expect(payin['Nature']).to eq('REGULAR')
    expect(payin['PaymentType']).to eq('BLIK')
    expect(payin['ExecutionType']).to eq('WEB')
    expect(payin['Status']).to eq('CREATED')
  end

  describe 'CREATE' do
    it 'creates a blik web payin' do
      created = new_payin_blik_web
      expect(created['Id']).not_to be_nil
      expect(created['ReturnURL']).not_to be_nil
      check_type_and_status(created)
    end

    it 'creates a blik web payin with code' do
      created = new_payin_blik_web_with_code
      expect(created['Id']).not_to be_nil
      expect(created['Code']).not_to be_nil
      expect(created['IpAddress']).not_to be_nil
      expect(created['BrowserInfo']).not_to be_nil
      check_type_and_status(created)
    end
  end

  describe 'FETCH' do
    it 'fetches a payin' do
      created = new_payin_blik_web
      fetched = MangoPay::PayIn.fetch(created['Id'])
      expect(fetched['Id']).to eq(created['Id'])
      check_type_and_status(created)
      check_type_and_status(fetched)
    end
  end

end
