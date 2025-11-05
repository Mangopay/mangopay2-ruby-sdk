describe MangoPay::Hook do
  include_context 'wallets'
  include_context 'payins'

  describe 'PAY_IN CARD DIRECT' do
    it 'creates a Card Direct PayIn' do
      created = create_new_pay_in_card_direct

      assert_common_pay_in_properties(created)
      expect(created['PaymentType']).to eq('CARD')
      expect(created['ExecutionType']).to eq('DIRECT')
    end
  end

  describe 'REFUND' do
    it 'creates a Refund for a PayIn' do
      pay_in = create_new_pay_in_card_direct
      refund = MangoPay::Acquiring::Refund.create(pay_in['Id'], { DebitedFunds: { Currency: 'EUR', Amount: 500 } })

      expect(refund['Id']).not_to be_nil
      expect(refund['Status']).to eq('SUCCEEDED')
      expect(refund['Type']).to eq('PAYOUT')
      expect(refund['Nature']).to eq('REFUND')
      expect(refund['InitialTransactionType']).to eq('PAYIN')
      expect(refund['InitialTransactionId']).to eq(pay_in['Id'])
    end
  end

  describe 'PAY_IN APPLE_PAY' do
    it 'creates an ApplePay direct PayIn' do
      created = MangoPay::Acquiring::PayIn::ApplePay::Direct.create(
        DebitedFunds: { Currency: 'EUR', Amount: 100 },
        PaymentData: {
          transactionId: "97e64d87f13a89ff6443cdcc205d5ccf7e15368b0d64126a8a2e0888a3a5c2a0",
          network: "MasterCard",
          tokenDataø: "{\"data\":\"2TihgKbmyPje02.........wAAAAAAAA==\",\"header\":{\"publicKeyHash\":\"xUyeFb75d359bfPEiq2JJMQj694UAxtTuBsaTWMOJxQ=\",\"ephemeralPublicKey\":\"MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEkeuICjZ7x15b7hPEBEBT5Zp43l95wCmJCU3QNxBvOCusG9w9sJMULuXlT4K8LOlPgaZzAcyWlfNwnLivVdOPfg==\",\"transactionId\":\"97e64d87f13a89ff6443cdcc205d5ccf7e15368b0d64126a8a2e0888a3a5c2a0\"},\"version\":\"EC_v1\"}"
        }
      )

      assert_common_pay_in_properties(created)
      expect(created['PaymentType']).to eq('APPLEPAY')
      expect(created['ExecutionType']).to eq('DIRECT')
    end
  end

  describe 'PAY_IN GOOGLE_PAY' do
    it 'creates a GooglePay direct PayIn' do
      created = MangoPay::Acquiring::PayIn::GooglePay::Direct.create(
        DebitedFunds: { Currency: 'EUR', Amount: 199 },
        IpAddress: "2001:0620:0000:0000:0211:24FF:FE80:C12C",
        SecureModeReturnURL: 'http://test.com',
        BrowserInfo: {
          AcceptHeader: "text/html, application/xhtml+xml, application/xml;q=0.9, /;q=0.8",
          JavaEnabled: true,
          Language: "fr-FR",
          ColorDepth: 4,
          ScreenHeight: 1800,
          ScreenWidth: 400,
          JavascriptEnabled: true,
          TimeZoneOffset: "+60",
          UserAgent: "Mozilla/5.0 (iPhone; CPU iPhone OS 13_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148"
        },
        PaymentData: "{\"signature\":\"MEUCIQDc49/Bw1lTk8ok2fUe4UT......................\\u003d\\\"}\"}"
      )

      assert_common_pay_in_properties(created)
      expect(created['PaymentType']).to eq('GOOGLEPAY')
      expect(created['ExecutionType']).to eq('DIRECT')
    end
  end

  describe 'PAY_IN IDEAL WEB' do
    it 'creates an Ideal Web PayIn' do
      created = MangoPay::Acquiring::PayIn::Ideal::Web.create(
        DebitedFunds: { Currency: 'EUR', Amount: 100 },
        ReturnURL: 'http://www.my-site.com/returnURL'
      )

      assert_common_pay_in_properties(created)
      expect(created['PaymentType']).to eq('IDEAL')
      expect(created['ExecutionType']).to eq('WEB')
    end
  end

  describe 'PAY_IN PAYPAL' do
    it 'creates a PayPal Web PayIn' do
      created = MangoPay::Acquiring::PayIn::PayPal::Web.create(
        DebitedFunds: { Currency: 'EUR', Amount: 400 },
        ReturnUrl: "http://example.com",
        LineItems: [
          {
            Name: "running shoes",
            Quantity: 1,
            UnitAmount: 200,
            TaxAmount: 0,
            Description: "seller1 ID"
          },
          {
            Name: "running shoes",
            Quantity: 1,
            UnitAmount: 200,
            TaxAmount: 0,
            Description: "seller2 ID"
          }
        ]
      )

      assert_common_pay_in_properties(created)
      expect(created['PaymentType']).to eq('PAYPAL')
      expect(created['ExecutionType']).to eq('WEB')
    end

    it 'creates PayPal DataCollection' do
      data_collection = MangoPay::Acquiring::PayIn::PayPal::Web.create_data_collection(
        {
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
      )
      expect(data_collection['dataCollectionId']).not_to be_nil
    end
  end

  def create_new_pay_in_card_direct
    card_registration = new_card_registration_completed
    MangoPay::Acquiring::PayIn::Card::Direct.create(
      DebitedFunds: { Currency: 'EUR', Amount: 1000 },
      CardType: 'CB_VISA_MASTERCARD',
      CardId: card_registration['CardId'],
      SecureMode: 'DEFAULT',
      SecureModeReturnURL: 'http://test.com',
      Tag: 'Acquiring Test PayIn/Card/Direct',
      BrowserInfo: {
        AcceptHeader: "text/html, application/xhtml+xml, application/xml;q=0.9, /;q=0.8",
        JavaEnabled: true,
        Language: "FR-FR",
        ColorDepth: 4,
        ScreenHeight: 1800,
        ScreenWidth: 400,
        JavascriptEnabled: true,
        TimeZoneOffset: "+60",
        UserAgent: "Mozilla/5.0 (iPhone; CPU iPhone OS 13_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148"
      },
      IpAddress: "2001:0620:0000:0000:0211:24FF:FE80:C12C"
    )
  end

  def assert_common_pay_in_properties(pay_in)
    expect(pay_in['Id']).not_to be_nil
    expect(pay_in['Type']).to eq('PAYIN')
    expect(pay_in['Nature']).to eq('REGULAR')
    expect(pay_in['Status']).to eq('SUCCEEDED')
    expect(pay_in['ResultCode']).to eq('000000')
    expect(pay_in['ResultMessage']).to eq('Success')
    expect(pay_in['ExecutionDate']).to be > 0
  end
end
