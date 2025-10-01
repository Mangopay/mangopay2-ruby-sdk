describe MangoPay::PayIn::PayPal::Web, type: :feature do
  include_context 'payins'

  def check_type_and_status(payin)
    expect(payin['Type']).to eq('PAYIN')
    expect(payin['Nature']).to eq('REGULAR')
    expect(payin['PaymentType']).to eq('PAYPAL')
    expect(payin['ExecutionType']).to eq('WEB')

    # not SUCCEEDED yet: waiting for processing
    expect(payin['Status']).to eq('CREATED')
    expect(payin['ResultCode']).to be_nil
    expect(payin['ResultMessage']).to be_nil
    expect(payin['ExecutionDate']).to be_nil
  end

  describe 'CREATE' do
    it 'creates a paypal web payin' do
      created = new_payin_paypal_web
      expect(created['Id']).not_to be_nil
      check_type_and_status(created)
    end
  end

  describe 'CREATE V2' do
    it 'creates a paypal web v2 payin' do
      created = new_payin_paypal_web_v2
      expect(created['Id']).not_to be_nil
      # generic operation error
      # check_type_and_status(created)
    end
  end

  describe "FETCH" do
    it 'FETCHES a payIn with PayPal account email' do
      pending("Expired PayIn id")
      payin_id = "54088959"
      buyer_account_email = "paypal-buyer-user@mangopay.com"
      payin = MangoPay::PayIn.fetch(id = payin_id)

      expect(payin).not_to be_nil
      expect(payin["PaypalBuyerAccountEmail"]).not_to be_nil
      expect(payin["PaypalBuyerAccountEmail"]).to eq(buyer_account_email)
    end
  end

  describe 'FETCH' do
    it 'fetches a payin' do
      created = new_payin_paypal_web
      fetched = MangoPay::PayIn.fetch(created['Id'])
      expect(fetched['Id']).to eq(created['Id'])
      expect(fetched['CreationDate']).to eq(created['CreationDate'])
      expect(fetched['CreditedFunds']).to eq(created['CreditedFunds'])
      expect(fetched['CreditedWalletId']).to eq(created['CreditedWalletId'])
      check_type_and_status(created)
      check_type_and_status(fetched)
    end
  end

  # skip because of Generic Operation Error
  describe 'FETCH V2' do
    xit 'fetches a payin' do
      created = new_payin_paypal_web_v2
      fetched = MangoPay::PayIn.fetch(created['Id'])
      expect(fetched['Id']).to eq(created['Id'])
      expect(fetched['CreationDate']).to eq(created['CreationDate'])
      expect(fetched['CreditedFunds']).to eq(created['CreditedFunds'])
      expect(fetched['CreditedWalletId']).to eq(created['CreditedWalletId'])
      check_type_and_status(created)
      check_type_and_status(fetched)
    end
  end

  describe 'Data Collection' do
    it 'creates data collection' do
      created = MangoPay::PayIn::PayPal::Web.create_data_collection(get_data_collection_dto)
      expect(created['dataCollectionId']).not_to be_nil
    end

    it 'fetches data collection' do
      created = MangoPay::PayIn::PayPal::Web.create_data_collection(get_data_collection_dto)
      fetched = MangoPay::PayIn::PayPal::Web.get_data_collection(created['dataCollectionId'])
      expect(fetched['DataCollectionId']).to eq(created['dataCollectionId'])
      expect(fetched['sender_first_name']).to eq('Jane')
      expect(fetched['sender_last_name']).to eq('Doe')
    end
  end

  def get_data_collection_dto
    return {
      "sender_account_id": "A12345N343",
      "sender_first_name": "Jane",
      "sender_last_name": "Doe",
      "sender_email": "jane.doe@sample.com",
      "sender_phone": "(042)11234567",
      "sender_address_zip": "75009",
      "sender_country_code": "FR",
      "sender_create_date": "2012-12-09T19:14:55.277-0:00",
      "sender_signup_ip": "10.220.90.20",
      "sender_popularity_score": "high",
      "receiver_account_id": "A12345N344",
      "receiver_create_date": "2012-12-09T19:14:55.277-0:00",
      "receiver_email": "jane@sample.com",
      "receiver_address_country_code": "FR",
      "business_name": "Jane Ltd",
      "recipient_popularity_score": "high",
      "first_interaction_date": "2012-12-09T19:14:55.277-0:00",
      "txn_count_total": "34",
      "vertical": "Household goods",
      "transaction_is_tangible": "0"
    }
  end
end
