###############################################
shared_context 'users' do
  ###############################################

  let(:new_natural_user) { create_new_natural_user }

  def define_new_natural_user
    {
        Tag: 'Test natural user',
        Email: 'my@email.com',
        FirstName: 'John',
        LastName: 'Doe',
        Address: {
            AddressLine1: 'Le Palais Royal',
            AddressLine2: '8 Rue de Montpensier',
            City: 'Paris',
            Region: '',
            PostalCode: '75001',
            Country: 'FR'
        },
        Birthday: 1_300_186_358,
        Birthplace: 'Paris',
        Nationality: 'FR',
        CountryOfResidence: 'FR',
        Occupation: 'Worker',
        IncomeRange: 1
    }
  end

  def create_new_natural_user
    MangoPay::NaturalUser.create(define_new_natural_user)
  end

  let(:new_legal_user) do
    MangoPay::LegalUser.create(
        Name: 'Super',
        Email: 'super@email.com',
        LegalPersonType: 'BUSINESS',
        HeadquartersAddress: {
            AddressLine1: '6 Parvis Notre-Dame',
            AddressLine2: 'Pl. Jean-Paul II',
            City: 'Paris',
            Region: 'FR',
            PostalCode: '75004',
            Country: 'FR'
        },
        LegalRepresentativeFirstName: 'John',
        LegalRepresentativeLastName: 'Doe',
        LegalRepresentativeAdress: {
            AddressLine1: '38 Rue de Montpensier',
            AddressLine2: '',
            City: 'Paris',
            Region: '',
            PostalCode: '75001',
            Country: 'FR'
        },
        LegalRepresentativeEmail: 'john@doe.com',
        LegalRepresentativeBirthday: 1_300_186_358,
        LegalRepresentativeNationality: 'FR',
        LegalRepresentativeCountryOfResidence: 'FR',
        CompanyNumber: 'LU123456789',
        Statute: '',
        ProofOfRegistration: '',
        ShareholderDeclaration: ''
    )
  end
end

###############################################
shared_context 'wallets' do
  ###############################################
  include_context 'users'

  let(:new_wallet) { create_new_wallet(new_natural_user) }
  let(:new_wallet_legal) { create_new_wallet(new_legal_user) }

  def create_new_wallet(user)
    MangoPay::Wallet.create(
        Owners: [user['Id']],
        Description: 'A test wallet',
        Currency: 'EUR',
        Tag: 'Test wallet'
    )
  end

  def wallets_check_amounts(wlt1, amnt1, wlt2 = nil, amnt2 = nil)
    expect(wlt1['Balance']['Amount']).to eq amnt1
    expect(wlt2['Balance']['Amount']).to eq amnt2 if wlt2
  end

  def wallets_reload_and_check_amounts(wlt1, amnt1, wlt2 = nil, amnt2 = nil)
    wlt1 = MangoPay::Wallet.fetch(wlt1['Id'])
    wlt2 = MangoPay::Wallet.fetch(wlt2['Id']) if wlt2
    wallets_check_amounts(wlt1, amnt1, wlt2, amnt2)
  end
end

shared_context 'ubo' do
  def new_ubo(user, ubo_declaration)
    ubo = {
        FirstName: 'John',
        LastName: 'Doe',
        Address: {
            AddressLine1: '6 Parvis Notre-Dame',
            AddressLine2: 'Pl. Jean-Paul II',
            City: 'Paris',
            Region: '',
            PostalCode: '75004',
            Country: 'FR'
        },
        Nationality: 'FR',
        Birthday: 1_300_186_358,
        Birthplace: {
            City: 'Paris',
            Country: 'FR'
        }
    }
    MangoPay::Ubo.create(user['Id'], ubo_declaration['Id'], ubo)
  end
end

###############################################
shared_context 'bank_accounts' do
  ###############################################
  include_context 'users'

  let(:new_bank_account) do
    MangoPay::BankAccount.create(new_natural_user['Id'],
                                 Type: 'IBAN',
                                 OwnerName: 'John',
                                 OwnerAddress: {
                                     AddressLine1: 'Le Palais Royal',
                                     AddressLine2: '8 Rue de Montpensier',
                                     City: 'Paris',
                                     Region: '',
                                     PostalCode: '75001',
                                     Country: 'FR'
                                 },
                                 IBAN: 'FR7630004000031234567890143',
                                 BIC: 'BNPAFRPP',
                                 Tag: 'Test bank account')
  end
end

###############################################
shared_context 'mandates' do
  ###############################################
  include_context 'bank_accounts'

  let(:new_mandate) { create_new_mandate }

  def create_new_mandate
    MangoPay::Mandate.create(
        BankAccountId: new_bank_account['Id'],
        Culture: 'FR',
        ReturnURL: MangoPay.configuration.root_url,
        Tag: 'Test mandate'
    )
  end
end

###############################################
shared_context 'kyc_documents' do
  ###############################################
  include_context 'users'

  let(:new_document) { create_new_document(new_natural_user) }

  def create_new_document(user)
    MangoPay::KycDocument.create(user['Id'],
                                 Type: 'IDENTITY_PROOF',
                                 Tag: 'Test document')
  end
end

###############################################
shared_context 'payins' do
  ###############################################
  include_context 'users'
  include_context 'wallets'
  include_context 'mandates'

  ###############################################
  # directdebit/web
  ###############################################

  let(:new_payin_directdebit_web) do
    MangoPay::PayIn::DirectDebit::Web.create(
        AuthorId: new_natural_user['Id'],
        CreditedUserId: new_wallet['Owners'][0],
        CreditedWalletId: new_wallet['Id'],
        DebitedFunds: {Currency: 'EUR', Amount: 1000},
        Fees: {Currency: 'EUR', Amount: 0},
        DirectDebitType: 'GIROPAY',
        ReturnURL: MangoPay.configuration.root_url,
        Culture: 'FR',
        Tag: 'Test PayIn/DirectDebit/Web'
    )
  end

  ###############################################
  # paypal/web
  ###############################################

  let(:new_payin_paypal_web) do
    MangoPay::PayIn::PayPal::Web.create(
        AuthorId: new_natural_user['Id'],
        CreditedUserId: new_wallet['Owners'][0],
        CreditedWalletId: new_wallet['Id'],
        DebitedFunds: {Currency: 'EUR', Amount: 1000},
        Fees: {Currency: 'EUR', Amount: 0},
        ReturnURL: MangoPay.configuration.root_url,
        Culture: "FR",
        Tag: 'Test PayIn/PayPal/Web'
    )
  end

  ###############################################
  # payconiq/web
  ###############################################

  let(:new_payin_payconiq_web) do
    MangoPay::PayIn::Payconiq::Web.create(
        AuthorId: new_natural_user['Id'],
        CreditedWalletId: new_wallet['Id'],
        DebitedFunds: {Currency: 'EUR', Amount: 100},
        Fees: {Currency: 'EUR', Amount: 0},
        ReturnURL: MangoPay.configuration.root_url,
        Country: "BE",
        Tag: 'Custom Meta'
    )
  end

  ###############################################
  # applepay/direct
  ###############################################

  let(:new_payin_applepay_direct) do
    MangoPay::PayIn::ApplePay::Direct.create(
        AuthorId: new_natural_user['Id'],
        CreditedUserId: new_wallet['Owners'][0],
        CreditedWalletId: new_wallet['Id'],
        DebitedFunds: {Currency: 'EUR', Amount: 199},
        Fees: {Currency: 'EUR', Amount: 1},
        PaymentType: 'APPLEPAY',
        PaymentData: {
            TransactionId: '061EB32181A2D9CA42AD16031B476EEBAA62A9A095AD660E2759FBA52B51A61',
            Network: 'VISA',
            TokenData: "{\"version\":\"EC_v1\",\"data\":\"w4HMBVqNC9ghPP4zncTA\\/0oQAsduERfsx78oxgniynNjZLANTL6+0koEtkQnW\\/K38Zew8qV1GLp+fLHo+qCBpiKCIwlz3eoFBTbZU+8pYcjaeIYBX9SOxcwxXsNGrGLk+kBUqnpiSIPaAG1E+WPT8R1kjOCnGvtdombvricwRTQkGjtovPfzZo8LzD3ZQJnHMsWJ8QYDLyr\\/ZN9gtLAtsBAMvwManwiaG3pOIWpyeOQOb01YcEVO16EZBjaY4x4C\\/oyFLWDuKGvhbJwZqWh1d1o9JT29QVmvy3Oq2JEjq3c3NutYut4rwDEP4owqI40Nb7mP2ebmdNgnYyWfPmkRfDCRHIWtbMC35IPg5313B1dgXZ2BmyZRXD5p+mr67vAk7iFfjEpu3GieFqwZrTl3\\/pI5V8Sxe3SIYKgT5Hr7ow==\",\"signature\":\"MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCAMIID5jCCA4ugAwIBAgIIaGD2mdnMpw8wCgYIKoZIzj0EAwIwejEuMCwGA1UEAwwlQXBwbGUgQXBwbGljYXRpb24gSW50ZWdyYXRpb24gQ0EgLSBHMzEmMCQGA1UECwwdQXBwbGUgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkxEzARBgNVBAoMCkFwcGxlIEluYy4xCzAJBgNVBAYTAlVTMB4XDTE2MDYwMzE4MTY0MFoXDTIxMDYwMjE4MTY0MFowYjEoMCYGA1UEAwwfZWNjLXNtcC1icm9rZXItc2lnbl9VQzQtU0FOREJPWDEUMBIGA1UECwwLaU9TIFN5c3RlbXMxEzARBgNVBAoMCkFwcGxlIEluYy4xCzAJBgNVBAYTAlVTMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEgjD9q8Oc914gLFDZm0US5jfiqQHdbLPgsc1LUmeY+M9OvegaJajCHkwz3c6OKpbC9q+hkwNFxOh6RCbOlRsSlaOCAhEwggINMEUGCCsGAQUFBwEBBDkwNzA1BggrBgEFBQcwAYYpaHR0cDovL29jc3AuYXBwbGUuY29tL29jc3AwNC1hcHBsZWFpY2EzMDIwHQYDVR0OBBYEFAIkMAua7u1GMZekplopnkJxghxFMAwGA1UdEwEB\\/wQCMAAwHwYDVR0jBBgwFoAUI\\/JJxE+T5O8n5sT2KGw\\/orv9LkswggEdBgNVHSAEggEUMIIBEDCCAQwGCSqGSIb3Y2QFATCB\\/jCBwwYIKwYBBQUHAgIwgbYMgbNSZWxpYW5jZSBvbiB0aGlzIGNlcnRpZmljYXRlIGJ5IGFueSBwYXJ0eSBhc3N1bWVzIGFjY2VwdGFuY2Ugb2YgdGhlIHRoZW4gYXBwbGljYWJsZSBzdGFuZGFyZCB0ZXJtcyBhbmQgY29uZGl0aW9ucyBvZiB1c2UsIGNlcnRpZmljYXRlIHBvbGljeSBhbmQgY2VydGlmaWNhdGlvbiBwcmFjdGljZSBzdGF0ZW1lbnRzLjA2BggrBgEFBQcCARYqaHR0cDovL3d3dy5hcHBsZS5jb20vY2VydGlmaWNhdGVhdXRob3JpdHkvMDQGA1UdHwQtMCswKaAnoCWGI2h0dHA6Ly9jcmwuYXBwbGUuY29tL2FwcGxlYWljYTMuY3JsMA4GA1UdDwEB\\/wQEAwIHgDAPBgkqhkiG92NkBh0EAgUAMAoGCCqGSM49BAMCA0kAMEYCIQDaHGOui+X2T44R6GVpN7m2nEcr6T6sMjOhZ5NuSo1egwIhAL1a+\\/hp88DKJ0sv3eT3FxWcs71xmbLKD\\/QJ3mWagrJNMIIC7jCCAnWgAwIBAgIISW0vvzqY2pcwCgYIKoZIzj0EAwIwZzEbMBkGA1UEAwwSQXBwbGUgUm9vdCBDQSAtIEczMSYwJAYDVQQLDB1BcHBsZSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTETMBEGA1UECgwKQXBwbGUgSW5jLjELMAkGA1UEBhMCVVMwHhcNMTQwNTA2MjM0NjMwWhcNMjkwNTA2MjM0NjMwWjB6MS4wLAYDVQQDDCVBcHBsZSBBcHBsaWNhdGlvbiBJbnRlZ3JhdGlvbiBDQSAtIEczMSYwJAYDVQQLDB1BcHBsZSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTETMBEGA1UECgwKQXBwbGUgSW5jLjELMAkGA1UEBhMCVVMwWTATBgcqhkjOPQIBBggqhkjOPQMBBwNCAATwFxGEGddkhdUaXiWBB3bogKLv3nuuTeCN\\/EuT4TNW1WZbNa4i0Jd2DSJOe7oI\\/XYXzojLdrtmcL7I6CmE\\/1RFo4H3MIH0MEYGCCsGAQUFBwEBBDowODA2BggrBgEFBQcwAYYqaHR0cDovL29jc3AuYXBwbGUuY29tL29jc3AwNC1hcHBsZXJvb3RjYWczMB0GA1UdDgQWBBQj8knET5Pk7yfmxPYobD+iu\\/0uSzAPBgNVHRMBAf8EBTADAQH\\/MB8GA1UdIwQYMBaAFLuw3qFYM4iapIqZ3r6966\\/ayySrMDcGA1UdHwQwMC4wLKAqoCiGJmh0dHA6Ly9jcmwuYXBwbGUuY29tL2FwcGxlcm9vdGNhZzMuY3JsMA4GA1UdDwEB\\/wQEAwIBBjAQBgoqhkiG92NkBgIOBAIFADAKBggqhkjOPQQDAgNnADBkAjA6z3KDURaZsYb7NcNWymK\\/9Bft2Q91TaKOvvGcgV5Ct4n4mPebWZ+Y1UENj53pwv4CMDIt1UQhsKMFd2xd8zg7kGf9F3wsIW2WT8ZyaYISb1T4en0bmcubCYkhYQaZDwmSHQAAMYIBizCCAYcCAQEwgYYwejEuMCwGA1UEAwwlQXBwbGUgQXBwbGljYXRpb24gSW50ZWdyYXRpb24gQ0EgLSBHMzEmMCQGA1UECwwdQXBwbGUgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkxEzARBgNVBAoMCkFwcGxlIEluYy4xCzAJBgNVBAYTAlVTAghoYPaZ2cynDzANBglghkgBZQMEAgEFAKCBlTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xOTA1MjMxMTA1MDdaMCoGCSqGSIb3DQEJNDEdMBswDQYJYIZIAWUDBAIBBQChCgYIKoZIzj0EAwIwLwYJKoZIhvcNAQkEMSIEIIvfGVQYBeOilcB7GNI8m8+FBVZ28QfA6BIXaggBja2PMAoGCCqGSM49BAMCBEYwRAIgU01yYfjlx9bvGeC5CU2RS5KBEG+15HH9tz\\/sg3qmQ14CID4F4ZJwAz+tXAUcAIzoMpYSnM8YBlnGJSTSp+LhspenAAAAAAAA\",\"header\":{\"ephemeralPublicKey\":\"MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAE0rs3wRpirXjPbFDQfPRdfEzRIZDWm0qn7Y0HB0PNzV1DDKfpYrnhRb4GEhBF\\/oEXBOe452PxbCnN1qAlqcSUWw==\",\"publicKeyHash\":\"saPRAqS7TZ4bAYwzBj8ezDDC55ZolyH1FL+Xc8fd93o=\",\"transactionId\":\"b061eb32181a2d9ca42ad16031b476eebaa62a9a095ad660e2759fba52b51a61\"}}"
        },
        StatementDescriptor: "php",
        ReturnURL: MangoPay.configuration.root_url,
        Tag: 'Test PayIn/ApplePay/Direct'
    )
  end

  ###############################################
  # CANNOT BE TESTED AS WE CAN'T MOCK TOKEN GENERATION
  # googlepay/direct
  ###############################################
  let(:new_payin_googlepay_direct) do
    MangoPay::PayIn::GooglePay::Direct.create(
        AuthorId: new_natural_user['Id'],
        CreditedUserId: new_wallet['Owners'][0],
        CreditedWalletId: new_wallet['Id'],
        DebitedFunds: {Currency: 'EUR', Amount: 199},
        Fees: {Currency: 'EUR', Amount: 1},
        PaymentData: {
            TransactionId: '061EB32181A2D9CA42AD16031B476EEBAA62A9A095AD660E2759FBA52B51A61',
            Network: 'VISA',
            TokenData: "tokenData"
        },
        StatementDescriptor: "ruby",
        ReturnURL: MangoPay.configuration.root_url,
        Tag: 'Test PayIn/GooglePay/Direct',
        Billing: {
            Address: {
                AddressLine1: 'AddressLine1',
                AddressLine2: 'AddressLine2',
                City: 'City',
                Region: 'Region',
                PostalCode: 'PostalCode',
                CountryIso: 'FR'
            }
        }
    )
  end


  ###############################################
  # directdebit/direct
  ###############################################

  let(:new_payin_directdebit_direct) do
    MangoPay::PayIn::DirectDebit::Direct.create(
        AuthorId: new_natural_user['Id'],
        CreditedUserId: new_wallet['Owners'][0],
        CreditedWalletId: new_wallet['Id'],
        DebitedFunds: {Currency: 'EUR', Amount: 1000},
        Fees: {Currency: 'EUR', Amount: 0},
        MandateId: new_mandate['Id'],
        ReturnURL: MangoPay.configuration.root_url,
        Tag: 'Test PayIn/DirectDebit/Direct'
    )
  end

  ###############################################
  # card/web
  ###############################################

  let(:new_payin_card_web) do
    MangoPay::PayIn::Card::Web.create(
        AuthorId: new_natural_user['Id'],
        CreditedUserId: new_wallet['Owners'][0],
        CreditedWalletId: new_wallet['Id'],
        DebitedFunds: {Currency: 'EUR', Amount: 1000},
        Fees: {Currency: 'EUR', Amount: 0},
        CardType: 'CB_VISA_MASTERCARD',
        ReturnURL: MangoPay.configuration.root_url,
        Culture: 'FR',
        Tag: 'Test PayIn/Card/Web'
    )
  end

  let(:new_payin_card_web_payline) do
    MangoPay::PayIn::Card::Web.create(
        AuthorId: new_natural_user['Id'],
        CreditedUserId: new_wallet['Owners'][0],
        CreditedWalletId: new_wallet['Id'],
        DebitedFunds: {Currency: 'EUR', Amount: 1000},
        Fees: {Currency: 'EUR', Amount: 0},
        CardType: 'CB_VISA_MASTERCARD',
        ReturnURL: MangoPay.configuration.root_url,
        Culture: 'FR',
        Tag: 'Test PayIn/Card/Web',
        TemplateURLOptions: {PAYLINEV2: "https://www.maysite.com/payline_template/"}
    )
  end

  ###############################################
  # card/direct
  ###############################################

  let(:new_card_registration) do
    MangoPay::CardRegistration.create(
        UserId: new_natural_user['Id'],
        Currency: 'EUR',
        Tag: 'Test Card Registration'
    )
  end

  let(:new_card_registration_completed) do
    # 1st step: create
    cardreg = new_card_registration

    # 2nd step: tokenize by payline (fills-in RegistrationData)
    data = {
        data: cardreg['PreregistrationData'],
        accessKeyRef: cardreg['AccessKey'],
        cardNumber: 4970105191923460,
        cardExpirationDate: 1226,
        cardCvx: 123}

    res = Net::HTTP.post_form(URI(cardreg['CardRegistrationURL']), data)
    raise Exception, [res, res.body] unless res.is_a?(Net::HTTPOK) && res.body.start_with?('data=')

    cardreg['RegistrationData'] = res.body

    # 3rd step: update (fills-in CardId) and return it
    MangoPay::CardRegistration.update(cardreg['Id'],
                                      RegistrationData: cardreg['RegistrationData'])
  end

  let(:new_card_registration_3dsecure_completed) do
    # 1st step: create
    cardreg = new_card_registration

    # 2nd step: tokenize by payline (fills-in RegistrationData)
    data = {
        data: cardreg['PreregistrationData'],
        accessKeyRef: cardreg['AccessKey'],
        cardNumber: 4970105191923460,
        cardExpirationDate: 1224,
        cardCvx: 123}

    res = Net::HTTP.post_form(URI(cardreg['CardRegistrationURL']), data)
    raise Exception, [res, res.body] unless res.is_a?(Net::HTTPOK) && res.body.start_with?('data=')

    cardreg['RegistrationData'] = res.body

    # 3rd step: update (fills-in CardId) and return it
    MangoPay::CardRegistration.update(cardreg['Id'],
                                      RegistrationData: cardreg['RegistrationData'])
  end

  let(:new_card_registration_completed_for_deposit) do
    # 1st step: create
    cardreg = new_card_registration

    # 2nd step: tokenize by payline (fills-in RegistrationData)
    data = {
        data: cardreg['PreregistrationData'],
        accessKeyRef: cardreg['AccessKey'],
        cardNumber: 4970105181818183,
        cardExpirationDate: 1226,
        cardCvx: 123}

    res = Net::HTTP.post_form(URI(cardreg['CardRegistrationURL']), data)
    raise Exception, [res, res.body] unless res.is_a?(Net::HTTPOK) && res.body.start_with?('data=')

    cardreg['RegistrationData'] = res.body

    # 3rd step: update (fills-in CardId) and return it
    MangoPay::CardRegistration.update(cardreg['Id'],
                                      RegistrationData: cardreg['RegistrationData'])
  end

  let(:new_payin_card_direct) { create_new_payin_card_direct(new_wallet) }

  ###############################################
  # MBWAY/direct
  ###############################################
  let(:new_payin_mbway_direct) do
    MangoPay::PayIn::Mbway::Direct.create(
      AuthorId: new_natural_user['Id'],
      CreditedWalletId: new_wallet['Id'],
      DebitedFunds: {Currency: 'EUR', Amount: 199},
      Fees: {Currency: 'EUR', Amount: 1},
      StatementDescriptor: "ruby",
      Tag: 'Test PayIn/Mbway/Direct',
      Phone: '351#269458236'
    )
  end

  ###############################################
  # PAYPAL/direct
  ###############################################
  let(:new_payin_paypal_direct) do
    MangoPay::PayIn::PayPal::Direct.create(
      AuthorId: new_natural_user['Id'],
      DebitedFunds: { Currency: 'EUR', Amount: 400 },
      Fees: { Currency: 'EUR', Amount: 0 },
      CreditedWalletId: new_wallet['Id'],
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
      ],
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
      StatementDescriptor: "ruby",
      Tag: 'Test',
      # Culture: 'FR'
    )
  end

  def create_new_payin_card_direct(to_wallet, amnt = 1000)
    cardreg = new_card_registration_completed
    MangoPay::PayIn::Card::Direct.create(
        AuthorId: new_natural_user['Id'],
        CreditedUserId: to_wallet['Owners'][0],
        CreditedWalletId: to_wallet['Id'],
        DebitedFunds: {Currency: 'EUR', Amount: amnt},
        Fees: {Currency: 'EUR', Amount: 0},
        CardType: 'CB_VISA_MASTERCARD',
        CardId: cardreg['CardId'],
        SecureModeReturnURL: 'http://test.com',
        Tag: 'Test PayIn/Card/Direct',
        Requested3DSVersion: 'V2_1',
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

  ###############################################
  # card/direct with pre-authorization
  ###############################################

  let(:new_card_preauthorization) { create_new_card_preauthorization(new_card_registration_completed) }

  def create_new_card_preauthorization(cardreg, amnt = 1000)
    MangoPay::PreAuthorization.create(
        AuthorId: new_natural_user['Id'],
        DebitedFunds: {Currency: 'EUR', Amount: amnt},
        CardId: cardreg['CardId'],
        SecureMode: 'DEFAULT',
        SecureModeReturnURL: 'http://test.com',
        Tag: 'Test Card PreAuthorization',
        Requested3DSVersion: 'V2_1',
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

  let(:new_payin_preauthorized_direct) { create_new_payin_preauthorized_direct(new_wallet) }

  def create_new_payin_preauthorized_direct(to_wallet, amnt = 1000)
    preauth = new_card_preauthorization
    MangoPay::PayIn::PreAuthorized::Direct.create(
        AuthorId: new_natural_user['Id'],
        CreditedUserId: to_wallet['Owners'][0],
        CreditedWalletId: to_wallet['Id'],
        DebitedFunds: {Currency: 'EUR', Amount: amnt},
        Fees: {Currency: 'EUR', Amount: 0},
        PreauthorizationId: preauth['Id'],
        Tag: 'Test PayIn/PreAuthorized/Direct',
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

  ###############################################
  # pre-authorized direct deposit
  ###############################################

  def create_new_payin_pre_authorized_deposit_direct(deposit_id, author_id, credited_wallet_id)
    MangoPay::PayIn::PreAuthorized::Direct.create_pre_authorized_deposit_pay_in(
        AuthorId: author_id,
        CreditedWalletId: credited_wallet_id,
        DebitedFunds: {Currency: 'EUR', Amount: 500},
        Fees: {Currency: 'EUR', Amount: 0},
        DepositId: deposit_id,
        Tag: 'lorem ipsum'
    )
  end

  ###############################################
  # bankwire/direct
  ###############################################

  let(:new_payin_bankwire_direct) { create_new_payin_bankwire_direct(new_wallet) }

  def create_new_payin_bankwire_direct(to_wallet, amnt = 1000)
    MangoPay::PayIn::BankWire::Direct.create(
        AuthorId: new_natural_user['Id'],
        CreditedUserId: to_wallet['Owners'][0],
        CreditedWalletId: to_wallet['Id'],
        DeclaredDebitedFunds: {Currency: 'EUR', Amount: amnt},
        DeclaredFees: {Currency: 'EUR', Amount: 0},
        Tag: 'Test PayIn/BankWire/Direct'
    )
  end
end

###############################################
shared_context 'payouts' do
  ###############################################
  include_context 'bank_accounts'

  let(:new_payout_bankwire) { create_new_payout_bankwire(new_payin_card_direct) }

  def create_new_payout_bankwire(payin, amnt = 500)
    MangoPay::PayOut::BankWire.create(
        AuthorId: payin['CreditedUserId'],
        DebitedWalletId: payin['CreditedWalletId'],
        DebitedFunds: {Currency: 'EUR', Amount: amnt},
        Fees: {Currency: 'EUR', Amount: 0},
        BankAccountId: new_bank_account['Id'],
        Communication: 'This is a test',
        Tag: 'Test PayOut/Bank/Wire',
        PayoutModeRequested: 'Standard'
    )
  end
end

###############################################
shared_context 'transfers' do
  ###############################################
  include_context 'users'
  include_context 'wallets'
  include_context 'payins'

  let(:new_transfer) do
    wlt1 = new_wallet
    wlt2 = new_wallet_legal
    create_new_payin_card_direct(wlt1, 1000) # feed wlt1 with money
    create_new_transfer(wlt1, wlt2, 500) # transfer wlt1 => wlt2
  end

  def create_new_transfer(from_wallet, to_wallet, amnt = 500)
    MangoPay::Transfer.create(
        AuthorId: from_wallet['Owners'][0],
        DebitedWalletId: from_wallet['Id'],
        CreditedUserId: to_wallet['Owners'][0],
        CreditedWalletId: to_wallet['Id'],
        DebitedFunds: {Currency: 'EUR', Amount: amnt},
        Fees: {Currency: 'EUR', Amount: 0},
        Tag: 'Test transfer'
    )
  end
end

###############################################
shared_context 'hooks' do
  ###############################################
  let(:new_hook) do
    hooks = MangoPay::Hook.fetch('page' => 1, 'per_page' => 1)
    if hooks.empty?
      MangoPay::Hook.create(
          EventType: 'PAYIN_NORMAL_CREATED',
          Url: 'http://test.com',
          Tag: 'Test hook'
      )
    else
      hooks[0]
    end
  end
end

###############################################
shared_context 'bankingaliases' do
  ###############################################
  include_context 'users'
  include_context 'wallets'

  let(:new_banking_alias) do
    MangoPay::BankingAliasesIBAN.create({
                                            CreditedUserId: new_natural_user['Id'],
                                            WalletId: new_wallet['Id'],
                                            OwnerName: new_natural_user['FirstName'],
                                            Country: 'LU'
                                        }, new_wallet['Id'])
  end
end


###############################################
# deposits
###############################################

def create_new_deposit(card_registration_id, author_id)
  MangoPay::Deposit.create(
      {
          AuthorId: author_id,
          DebitedFunds: {Currency: 'EUR', Amount: 1000},
          CardId: card_registration_id,
          SecureModeReturnURL: 'http://mangopay-sandbox-test.com',
          StatementDescriptor: "lorem",
          Culture: 'FR',
          IpAddress: "2001:0620:0000:0000:0211:24FF:FE80:C12C",
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
          }
      }
  )
end