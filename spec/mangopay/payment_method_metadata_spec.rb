describe MangoPay::PaymentMethodMetadata, type: :feature do
  include_context 'payment_method_metadata'

  describe 'GET PAYMENT METHOD METADATA' do
    it 'gets a new payment method metadata' do
      metadata = get_payment_method_metadata

      expect(metadata).not_to be_nil
      expect(metadata['IssuerCountryCode']).not_to be_nil
      expect(metadata['IssuingBank']).not_to be_nil
      expect(metadata['BinData']).not_to be_nil
      expect(metadata['CardType']).not_to be_nil
    end
  end
end