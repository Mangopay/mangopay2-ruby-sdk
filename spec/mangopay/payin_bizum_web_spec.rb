describe MangoPay::PayIn::Bizum::Web, type: :feature do
  include_context 'wallets'
  include_context 'payins'

  def check_type_and_status(payin)
    expect(payin['Type']).to eq('PAYIN')
    expect(payin['PaymentType']).to eq('BIZUM')
    expect(payin['ExecutionType']).to eq('WEB')
    expect(payin['Status']).to eq('CREATED')
  end

  describe 'CREATE' do
    it 'creates a bizum web payin with phone' do
      created = new_payin_bizum_web_with_phone
      expect(created['Id']).not_to be_nil
      expect(created['Phone']).not_to be_nil
      expect(created['ReturnURL']).to be_nil
      check_type_and_status(created)
    end

    it 'creates a bizum web payin with return url' do
      created = new_payin_bizum_web_with_return_url
      expect(created['Id']).not_to be_nil
      expect(created['Phone']).to be_nil
      expect(created['ReturnURL']).not_to be_nil
      check_type_and_status(created)
    end
  end

  describe 'FETCH' do
    it 'fetches a bizum payin with phone' do
      created = new_payin_bizum_web_with_phone
      fetched = MangoPay::PayIn.fetch(created['Id'])
      expect(fetched['Id']).to eq(created['Id'])
      expect(fetched['Phone']).not_to be_nil
      expect(fetched['Phone']).to eq(created['Phone'])
      expect(fetched['ReturnURL']).to be_nil
      expect(fetched['ReturnURL']).to eq(created['ReturnURL'])
      check_type_and_status(created)
      check_type_and_status(fetched)
    end

    it 'fetches a bizum payin with return url' do
      created = new_payin_bizum_web_with_return_url
      fetched = MangoPay::PayIn.fetch(created['Id'])
      expect(fetched['Id']).to eq(created['Id'])
      expect(fetched['ReturnURL']).not_to be_nil
      expect(fetched['Phone']).to be_nil
      expect(fetched['ReturnURL']).to eq(created['ReturnURL'])
      check_type_and_status(created)
      check_type_and_status(fetched)
    end
  end
end