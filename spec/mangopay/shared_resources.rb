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
                                 IBAN: 'FR7618829754160173622224154',
                                 BIC: 'CMBRFR2BCME',
                                 Tag: 'Test bank account')
  end
end

###############################################
shared_context 'mandates' do
  ###############################################
  include_context 'bank_accounts'

  let(:new_mandate) {create_new_mandate}

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
      DebitedFunds: { Currency: 'EUR', Amount: 1000 },
      Fees: { Currency: 'EUR', Amount: 0 },
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
      DebitedFunds: { Currency: 'EUR', Amount: 1000 },
      Fees: { Currency: 'EUR', Amount: 0 },
      ReturnURL: MangoPay.configuration.root_url,
      Tag: 'Test PayIn/PayPal/Web'
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
      DebitedFunds: { Currency: 'EUR', Amount: 1000 },
      Fees: { Currency: 'EUR', Amount: 0 },
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
      DebitedFunds: { Currency: 'EUR', Amount: 1000 },
      Fees: { Currency: 'EUR', Amount: 0 },
      CardType: 'CB_VISA_MASTERCARD',
      ReturnURL: MangoPay.configuration.root_url,
      Culture: 'FR',
      Tag: 'Test PayIn/Card/Web'
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
      cardNumber: 4970100000000154,
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
  def create_new_payin_card_direct(to_wallet, amnt = 1000)
    cardreg = new_card_registration_completed
    MangoPay::PayIn::Card::Direct.create(
      AuthorId: new_natural_user['Id'],
      CreditedUserId: to_wallet['Owners'][0],
      CreditedWalletId: to_wallet['Id'],
      DebitedFunds: { Currency: 'EUR', Amount: amnt },
      Fees: { Currency: 'EUR', Amount: 0 },
      CardType: 'CB_VISA_MASTERCARD',
      CardId: cardreg['CardId'],
      SecureModeReturnURL: 'http://test.com',
      Tag: 'Test PayIn/Card/Direct'
    )
  end

  ###############################################
  # card/direct with pre-authorization
  ###############################################

  let(:new_card_preauthorization) { create_new_card_preauthorization(new_card_registration_completed) }
  def create_new_card_preauthorization(cardreg, amnt = 1000)
    MangoPay::PreAuthorization.create(
      AuthorId: new_natural_user['Id'],
      DebitedFunds: { Currency: 'EUR', Amount: amnt },
      CardId: cardreg['CardId'],
      SecureMode: 'DEFAULT',
      SecureModeReturnURL: 'http://test.com',
      Tag: 'Test Card PreAuthorization'
    )
  end

  let(:new_payin_preauthorized_direct) { create_new_payin_preauthorized_direct(new_wallet) }
  def create_new_payin_preauthorized_direct(to_wallet, amnt = 1000)
    preauth = new_card_preauthorization
    MangoPay::PayIn::PreAuthorized::Direct.create(
      AuthorId: new_natural_user['Id'],
      CreditedUserId: to_wallet['Owners'][0],
      CreditedWalletId: to_wallet['Id'],
      DebitedFunds: { Currency: 'EUR', Amount: amnt },
      Fees: { Currency: 'EUR', Amount: 0 },
      PreauthorizationId: preauth['Id'],
      Tag: 'Test PayIn/PreAuthorized/Direct'
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
      DeclaredDebitedFunds: { Currency: 'EUR', Amount: amnt },
      DeclaredFees: { Currency: 'EUR', Amount: 0 },
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
      DebitedFunds: { Currency: 'EUR', Amount: amnt },
      Fees: { Currency: 'EUR', Amount: 0 },
      BankAccountId: new_bank_account['Id'],
      Communication: 'This is a test',
      Tag: 'Test PayOut/Bank/Wire'
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
shared_context 'bankigaliases' do
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
