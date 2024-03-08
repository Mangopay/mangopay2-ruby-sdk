describe MangoPay::Conversion, type: :feature do
  include_context 'instant_conversion'

  describe 'GET CONVERSION RATE' do
    it 'get a conversion rate' do
      conversion_rate = get_conversion_rate('EUR','GBP')

      expect(conversion_rate['ClientRate']).not_to be_nil
      expect(conversion_rate['MarketRate']).not_to be_nil
    end
  end

  describe 'CREATE INSTANT CONVERSION' do
    it 'creates a new instant conversion' do
      conversion = create_instant_conversion

      expect(conversion['DebitedFunds']['Amount']).not_to be_nil
      expect(conversion['CreditedFunds']['Amount']).not_to be_nil
      expect(conversion['Fees']['Amount']).not_to be_nil
      expect(conversion['Status']).equal? 'SUCCEEDED'
    end
  end

  describe 'CREATE QUOTED CONVERSION' do
    it 'creates a new quoted conversion' do
      conversion = create_quoted_conversion

      expect(conversion['DebitedFunds']['Amount']).not_to be_nil
      expect(conversion['CreditedFunds']['Amount']).not_to be_nil
      expect(conversion['Status']).equal? 'SUCCEEDED'
    end
  end

  describe 'GET EXISTING CONVERSION' do
    it 'get an existing conversion' do
      conversion = create_instant_conversion
      returned_conversion = get_conversion(conversion['Id'])

      expect(returned_conversion['DebitedFunds']['Amount']).not_to be_nil
      expect(returned_conversion['CreditedFunds']['Amount']).not_to be_nil
      expect(conversion['Fees']['Amount']).not_to be_nil
      expect(returned_conversion['Status']).equal? 'SUCCEEDED'
    end
  end

  describe 'CREATE CONVERSION QUOTE' do
    it 'create a conversion quote' do
      conversion_quote = create_conversion_quote
      expect(conversion_quote['DebitedFunds']).not_to be_nil
      expect(conversion_quote['CreditedFunds']).not_to be_nil
      expect(conversion_quote['Duration']).equal? 90
    end
  end

  describe 'GET CONVERSION QUOTE' do
    it 'get a conversion quote' do
      conversion_quote = create_conversion_quote
      returned_conversion_quote = get_conversion_quote(conversion_quote['Id'])
      expect(returned_conversion_quote['DebitedFunds']).not_to be_nil
      expect(returned_conversion_quote['CreditedFunds']).not_to be_nil
      expect(returned_conversion_quote['Duration']).equal? 90
    end
  end
end