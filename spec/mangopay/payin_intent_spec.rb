describe MangoPay::PayIn::PayInIntent, type: :feature do
  include_context 'wallets'
  include_context 'intents'

  describe 'CREATE' do
    it 'creates a payin intent authorization' do
      created = new_payin_intent_authorization
      expect(created['Id']).not_to be_nil
      expect(created['Status']).to eq('AUTHORIZED')
    end

    it 'creates a payin intent full capture' do
      intent = new_payin_intent_authorization
      to_create = {
        "ExternalData": {
          "ExternalProcessingDate": "01-10-2029",
          "ExternalProviderReference": SecureRandom.uuid,
          "ExternalMerchantReference": "Order-xyz-35e8490e-2ec9-4c82-978e-c712a3f5ba16",
          "ExternalProviderName": "Stripe",
          "ExternalProviderPaymentMethod": "PAYPAL"
        }
      }

      created = MangoPay::PayIn::PayInIntent::Capture.create(intent['Id'], to_create)
      expect(created['Id']).not_to be_nil
      expect(created['Status']).to eq('CAPTURED')
    end

    it 'creates a payin intent partial capture' do
      intent = new_payin_intent_authorization
      to_create = {
        "Amount": 1000,
        "Currency": "EUR",
        "PlatformFeesAmount": 0,
        "ExternalData": {
          "ExternalProcessingDate": "01-10-2024",
          "ExternalProviderReference": SecureRandom.uuid,
          "ExternalMerchantReference": "Order-xyz-35e8490e-2ec9-4c82-978e-c712a3f5ba16",
          "ExternalProviderName": "Stripe",
          "ExternalProviderPaymentMethod": "PAYPAL"
        },
        "LineItems": [
          {
            "Amount": 1000,
            "Id": intent['LineItems'][0]['Id']
          }
        ]
      }

      created = MangoPay::PayIn::PayInIntent::Capture.create(intent['Id'], to_create)
      expect(created['Id']).not_to be_nil
      expect(created['Status']).to eq('CAPTURED')
    end
  end

  describe 'GET' do
    it 'fetches an intent' do
      intent = new_payin_intent_authorization
      fetched =  MangoPay::PayIn::PayInIntent::Intent.get(intent['Id'])
      expect(intent['Id']).to eq(fetched['Id'])
      expect(intent['Status']).to eq(fetched['Status'])
    end
  end
end