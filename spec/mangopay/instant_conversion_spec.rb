describe MangoPay::InstantConversion, type: :feature do
  include_context 'instant_conversion'

  describe 'GET CONVERSION RATE' do
    it 'get a conversion rate' do
      conversion_rate = get_conversion_rate('EUR','GBP')

      expect(conversion_rate['ClientRate']).not_to be_nil
      expect(conversion_rate['MarketRate']).not_to be_nil
    end
  end

  describe 'CREATE CONVERSION' do
    it 'creates a new conversion' do
      conversion = create_instant_conversion

      expect(conversion['DebitedFunds']['Amount']).not_to be_nil
      expect(conversion['CreditedFunds']['Amount']).not_to be_nil
      expect(conversion['Status']).equal? 'SUCCEEDED'
    end
  end

  describe 'GET EXISTING CONVERSION' do
    it 'get an existing conversion' do
      conversion = create_instant_conversion
      returned_conversion = get_instant_conversion(conversion['Id'])

      expect(returned_conversion['DebitedFunds']['Amount']).not_to be_nil
      expect(returned_conversion['CreditedFunds']['Amount']).not_to be_nil
      expect(returned_conversion['Status']).equal? 'SUCCEEDED'
    end
  end
end