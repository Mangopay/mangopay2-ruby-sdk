###############################################
shared_context 'clients' do
###############################################

  require 'securerandom'

  let(:client_id) {
    SecureRandom.hex(10)
  }

  let(:wrong_client_id) {
    SecureRandom.hex(20)
  }

  let(:wrong_client) {
    MangoPay::Client.create({
      'ClientID' => wrong_client_id,
      'Name' => 'What a nice name',
      'Email' => 'clientemail@email.com'
    })
  }

  let(:new_client) {
    MangoPay::Client.create({
      'ClientID' => client_id,
      'Name' => 'What a nice name',
      'Email' => 'clientemail@email.com'
    })
  }
end

###############################################
shared_context 'users' do
###############################################

  let(:new_natural_user) {
    MangoPay::NaturalUser.create({
      Tag: 'test',
      Email: 'my@email.com',
      FirstName: 'John',
      LastName: 'Doe',
      Address: 'Here',
      Birthday: '',
      Birthplace: 'Paris',
      Nationality: 'FR',
      CountryOfResidence: 'FR',
      Occupation: 'Worker',
      IncomeRange: 1
    })
  }

  let(:new_legal_user) {
    MangoPay::LegalUser.create({
      Name: 'Super',
      LegalPersonType: 'BUSINESS',
      HeadquartersAddress: 'Here',
      LegalRepresentativeFirstName: 'John',
      LegalRepresentativeLastName: 'Doe',
      LegalRepresentativeAdress: 'Here',
      LegalRepresentativeEmail: 'john@doe.com',
      LegalRepresentativeBirthday: '',
      LegalRepresentativeNationality: 'FR',
      LegalRepresentativeCountryOfResidence: 'FR',
      Statute: '',
      ProofOfRegistration: '',
      ShareholderDeclaration: ''
    })
  }
end

###############################################
shared_context 'wallets' do
###############################################

  let(:new_wallet) {
    MangoPay::Wallet.create({
      Owners: [new_natural_user['Id']],
      Description: 'A test wallet',
      Currency: 'EUR',
      Tag: 'Test Time'
    })
  }
end

###############################################
shared_context 'bank_details' do
###############################################

  let(:new_iban_bank_detail) {
    MangoPay::BankAccount.create(new_natural_user['Id'], {
      Type: 'IBAN',
      OwnerName: 'John',
      OwnerAddress: 'Here',
      IBAN: 'FR76 1790 6000 3200 0833 5232 973',
      BIC: 'AGRIFRPP879',
      Tag: 'Test Time'
    })
  }
end

###############################################
shared_context 'payins' do
###############################################
  
  ###############################################
  # card/web
  ###############################################

  let(:new_payin_card_web) {
    MangoPay::PayIn::Card::Web.create({
      AuthorId: new_natural_user['Id'],
      CreditedUserId: new_wallet['Owners'][0],
      CreditedWalletId: new_wallet['Id'],
      DebitedFunds: { Currency: 'EUR', Amount: 1000 },
      Fees: { Currency: 'EUR', Amount: 0 },
      CardType: 'CB_VISA_MASTERCARD',
      ReturnURL: MangoPay.configuration.root_url,
      Culture: 'FR',
      Tag: 'Test PayIn/Card/Web'
    })
  }

  ###############################################
  # card/direct
  ###############################################

  let(:new_card_registration) {
    MangoPay::CardRegistration.create({
      UserId: new_natural_user['Id'],
      Currency: 'EUR',
      Tag: 'Test Card Registration'
    })
  }

  let(:new_card_registration_completed) {
    # 1st step: create
    cardreg = new_card_registration

    # 2nd step: tokenize by payline (fills-in RegistrationData)
    data = {
      data: cardreg['PreregistrationData'],
      accessKeyRef: cardreg['AccessKey'],
      cardNumber: 4970101122334406,
      cardExpirationDate: 1214,
      cardCvx: 123}
    res = Net::HTTP.post_form(URI(cardreg['CardRegistrationURL']), data)
    raise Exception, [res, res.body] if (!res.is_a?(Net::HTTPOK) || !res.body.start_with?('data='))
    cardreg['RegistrationData'] = res.body

    # 3rd step: update (fills-in CardId) and return it
    MangoPay::CardRegistration.update(cardreg['Id'], {
      RegistrationData: cardreg['RegistrationData']
    })
  }

  let(:new_payin_card_direct) {
    cardreg = new_card_registration_completed
    MangoPay::PayIn::Card::Direct.create({
      AuthorId: new_natural_user['Id'],
      CreditedUserId: new_wallet['Owners'][0],
      CreditedWalletId: new_wallet['Id'],
      DebitedFunds: { Currency: 'EUR', Amount: 1000 },
      Fees: { Currency: 'EUR', Amount: 0 },
      CardType: 'CB_VISA_MASTERCARD',
      CardId: cardreg['CardId'],
      SecureModeReturnURL: 'http://test.com',
      Tag: 'Test PayIn/Card/Direct'
    })
  }

end

###############################################
shared_context 'transfer' do
###############################################

  let(:credited_wallet) {
    MangoPay::Wallet.create({
      Owners: [new_natural_user['Id']],
      Description: 'A test wallet',
      Currency: 'EUR',
      Tag: 'Test Time'
    })
  }

  let(:debited_wallet) {
    MangoPay::Wallet.create({
      Owners: [new_legal_user['Id']],
      Description: 'A test wallet',
      Currency: 'EUR',
      Tag: 'Test Time'
    })
  }

  let(:web_card_contribution) {
    card = MangoPay::PayIn::Card::Web.create({
      AuthorId: debited_wallet['Owners'][0],
      CreditedUserId: debited_wallet['Owners'][0],
      DebitedFunds: { Currency: 'EUR', Amount: 1000 },
      Fees: { Currency: 'EUR', Amount: 0 },
      CreditedWalletId: debited_wallet['Id'],
      CardType: 'CB_VISA_MASTERCARD',
      ReturnURL: MangoPay.configuration.root_url,
      Culture: 'FR',
      Tag: 'Test PayIn/Card/Web'
    })
#    visit(card['RedirectURL'])
#    fill_in('number', with: '4970100000000154')
#    fill_in('cvv', with: '123')
#    click_button('paybutton')
#    card = MangoPay::PayIn.fetch(card['Id'])
#    while card["Status"] == 'CREATED' do
#      card = MangoPay::PayIn.fetch(card['Id'])
#    end
    card
  }

  let(:new_transfer) {
    MangoPay::Transfer.create({
      AuthorId: web_card_contribution['CreditedUserId'],
      CreditedUserId: credited_wallet['Owners'][0],
      DebitedFunds: { Currency: 'EUR', Amount: 500},
      Fees: { Currency: 'EUR', Amout: 0},
      DebitedWalletId: web_card_contribution['CreditedWalletId'],
      CreditedWalletId: credited_wallet['Id'],
      Tag: 'Test Transfer'
    })
  }
end
