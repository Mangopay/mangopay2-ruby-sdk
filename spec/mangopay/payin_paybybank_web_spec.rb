describe MangoPay::PayIn::PayByBank::Web, type: :feature do
  include_context 'wallets'
  include_context 'payins'

  def check_type_and_status(payin)
    expect(payin['Type']).to eq('PAYIN')
    expect(payin['Nature']).to eq('REGULAR')
    expect(payin['PaymentType']).to eq('PAY_BY_BANK')
    expect(payin['ExecutionType']).to eq('WEB')
    expect(payin['Status']).to eq('CREATED')
  end

  describe 'CREATE' do
    it 'creates a paybybank web payin' do
      created = new_payin_paybybank_web
      expect(created['Id']).not_to be_nil
      check_type_and_status(created)
    end
  end

  describe 'FETCH' do
    it 'fetches a payin' do
      created = new_payin_paybybank_web
      fetched = MangoPay::PayIn.fetch(created['Id'])
      expect(fetched['Id']).to eq(created['Id'])
      check_type_and_status(created)
      check_type_and_status(fetched)
    end
  end

  describe "FETCH SUPPORTED BANKS" do
    it "fetches supported banks unfiltered" do
      result = MangoPay::PayIn::PayByBank::Web.get_supported_banks
      expect(result['SupportedBanks']['Countries']).to be_kind_of(Array)
      expect(result['SupportedBanks']['Countries']).not_to be_empty
    end

    it "fetches supported banks filtered" do
      result = MangoPay::PayIn::PayByBank::Web.get_supported_banks({CountryCodes: "DE"})
      expect(result['SupportedBanks']['Countries']).to be_kind_of(Array)
      expect(result['SupportedBanks']['Countries'][0]['Banks'].count).to be(5)
    end

    it "fetches supported banks paginated" do
      result = MangoPay::PayIn::PayByBank::Web.get_supported_banks({per_page: 2, page: 1})
      expect(result['SupportedBanks']['Countries']).to be_kind_of(Array)
      expect(result['SupportedBanks']['Countries'][0]['Banks'].count).to be(2)
    end

    it "fetches supported banks paginated and filtered" do
      result = MangoPay::PayIn::PayByBank::Web.get_supported_banks({per_page: 2, page: 1, CountryCodes: "DE"})
      expect(result['SupportedBanks']['Countries']).to be_kind_of(Array)
      expect(result['SupportedBanks']['Countries'][0]['Banks'].count).to be(2)
    end
  end
end