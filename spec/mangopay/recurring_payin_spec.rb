describe MangoPay::PayIn::RecurringPayments, type: :feature do
  include_context 'wallets'
  include_context 'users'
  include_context 'payins'

  describe 'CREATE' do
    it 'creates a recurring payment' do
      cardreg = new_card_registration_completed
      wallet = new_wallet
      recurring = MangoPay::PayIn::RecurringPayments::Recurring.create(
        AuthorId: new_natural_user['Id'],
        CardId: cardreg['CardId'],
        CreditedUserId: wallet['Owners'][0],
        CreditedWalletId: wallet['Id'],
        FirstTransactionDebitedFunds: {Currency: 'EUR', Amount: 10},
        FirstTransactionFees: {Currency: 'EUR', Amount: 1},
        Billing: {
          Address: {
            AddressLine1: 'AddressLine1',
            AddressLine2: 'AddressLine2',
            City: 'City',
            Region: 'Region',
            PostalCode: 'PostalCode',
            Country: 'FR'
          },
          FirstName: 'Joe',
          LastName: 'Blogs'
        },
        Shipping: {
          Address: {
            AddressLine1: 'AddressLine1',
            AddressLine2: 'AddressLine2',
            City: 'City',
            Region: 'Region',
            PostalCode: 'PostalCode',
            Country: 'FR'
          },
          FirstName: 'Joe',
          LastName: 'Blogs'
        },
        FreeCycles: 0
      )
      expect(recurring).not_to be_nil
      expect(recurring['Status']).not_to be_nil
      expect(recurring['Id']).not_to be_nil
      expect(recurring['FreeCycles']).not_to be_nil

      id = recurring['Id']

      get = MangoPay::PayIn::RecurringPayments::Recurring.fetch(id)
      expect(get).not_to be_nil
      expect(get['FreeCycles']).not_to be_nil

      cit = MangoPay::PayIn::RecurringPayments::CIT.create(
        RecurringPayinRegistrationId: recurring['Id'],
        IpAddress: "2001:0620:0000:0000:0211:24FF:FE80:C12C",
        SecureModeReturnURL: "http://www.my-site.com/returnurl",
        StatementDescriptor: "lorem",
        Tag: "custom meta",
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
        }
      )

      expect(cit).not_to be_nil

      update = MangoPay::PayIn::RecurringPayments::Recurring.update(id, {
        Status: 'Ended'
      })

      expect(update).not_to be_nil
    end

    it 'creates a recurring paypal payment CIT' do
      wallet = new_wallet
      recurring = MangoPay::PayIn::RecurringPayments::Recurring.create(
        AuthorId: new_natural_user['Id'],
        CreditedUserId: wallet['Owners'][0],
        CreditedWalletId: wallet['Id'],
        FirstTransactionDebitedFunds: {Currency: 'EUR', Amount: 1000},
        FirstTransactionFees: {Currency: 'EUR', Amount: 0},
        Billing: {
          Address: {
            AddressLine1: 'AddressLine1',
            AddressLine2: 'AddressLine2',
            City: 'City',
            Region: 'Region',
            PostalCode: 'PostalCode',
            Country: 'FR'
          },
          FirstName: 'Joe',
          LastName: 'Blogs'
        },
        Shipping: {
          Address: {
            AddressLine1: 'AddressLine1',
            AddressLine2: 'AddressLine2',
            City: 'City',
            Region: 'Region',
            PostalCode: 'PostalCode',
            Country: 'FR'
          },
          FirstName: 'Joe',
          LastName: 'Blogs'
        },
        PaymentType: 'PAYPAL'
      )
      expect(recurring).not_to be_nil
      expect(recurring['Status']).not_to be_nil
      expect(recurring['Id']).not_to be_nil

      cit = MangoPay::PayIn::RecurringPayments::PayPalCIT.create(
        {
          "ReturnURL": "http://example.com",
          "CancelURL": "http://example.net",
          "LineItems": [
            {
              "Name": "Running shoes",
              "Quantity": 1,
              "UnitAmount": 1000,
              "TaxAmount": 0,
              "Description": "ID of Seller 1",
              "Category": "PHYSICAL_GOODS"
            }
          ],
          "Tag": "Created using the Mangopay API Postman collection",
          "RecurringPayinRegistrationId": recurring['Id'],
          "ShippingPreference": "SET_PROVIDED_ADDRESS",
          "Reference": "abcd-efgh-ijkl",
          "StatementDescriptor": "Example123"
        }
      )

      expect(cit).not_to be_nil
      # expect(cit['Status']).to eq('CREATED')
      expect(cit['PaymentType']).to eq('PAYPAL')
      expect(cit['ExecutionType']).to eq('WEB')
    end

    it 'creates a recurring paypal payment MIT' do
      wallet = new_wallet
      recurring = MangoPay::PayIn::RecurringPayments::Recurring.create(
        AuthorId: new_natural_user['Id'],
        CreditedUserId: wallet['Owners'][0],
        CreditedWalletId: wallet['Id'],
        FirstTransactionDebitedFunds: {Currency: 'EUR', Amount: 1000},
        FirstTransactionFees: {Currency: 'EUR', Amount: 0},
        Billing: {
          Address: {
            AddressLine1: 'AddressLine1',
            AddressLine2: 'AddressLine2',
            City: 'City',
            Region: 'Region',
            PostalCode: 'PostalCode',
            Country: 'FR'
          },
          FirstName: 'Joe',
          LastName: 'Blogs'
        },
        Shipping: {
          Address: {
            AddressLine1: 'AddressLine1',
            AddressLine2: 'AddressLine2',
            City: 'City',
            Region: 'Region',
            PostalCode: 'PostalCode',
            Country: 'FR'
          },
          FirstName: 'Joe',
          LastName: 'Blogs'
        },
        PaymentType: 'PAYPAL'
      )
      expect(recurring).not_to be_nil
      expect(recurring['Status']).not_to be_nil
      expect(recurring['Id']).not_to be_nil

      cit = MangoPay::PayIn::RecurringPayments::PayPalMIT.create(
        {
          "ReturnURL": "http://example.com",
          "CancelURL": "http://example.net",
          "LineItems": [
            {
              "Name": "Running shoes",
              "Quantity": 1,
              "UnitAmount": 1000,
              "TaxAmount": 0,
              "Description": "ID of Seller 1",
              "Category": "PHYSICAL_GOODS"
            }
          ],
          "Tag": "Created using the Mangopay API Postman collection",
          "RecurringPayinRegistrationId": recurring['Id'],
          "ShippingPreference": "SET_PROVIDED_ADDRESS",
          "Reference": "abcd-efgh-ijkl",
          "StatementDescriptor": "Example123",
          "DebitedFunds": {
            "Currency": "EUR",
            "Amount": 1000
          },
          "Fees": {
            "Currency": "EUR",
            "Amount": 0
          }
        }
      )

      expect(cit).not_to be_nil
      # expect(cit['Status']).to eq('CREATED')
      expect(cit['PaymentType']).to eq('PAYPAL')
      expect(cit['ExecutionType']).to eq('WEB')
    end
  end
end