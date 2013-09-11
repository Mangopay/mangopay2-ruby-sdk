shared_context 'clients' do

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

shared_context 'users' do

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

shared_context 'wallets' do

  let(:new_wallet) {
    MangoPay::Wallet.create({
      Owners: [new_natural_user['Id']],
      Description: 'A test wallet',
      Currency: 'EUR',
      Tag: 'Test Time'
    })
  }
end

shared_context 'bank_details' do

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

shared_context 'payin_card_web' do
  let(:new_payin_card_web) {
    card = MangoPay::PayIn::Card::Web.create({
      AuthorId: new_natural_user['Id'],
      CreditedUserId: new_wallet['Owners'][0],
      DebitedFunds: { Currency: 'EUR', Amount: 1000 },
      Fees: { Currency: 'EUR', Amount: 0 },
      CreditedWalletId: new_wallet['Id'],
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
end

shared_context 'payout_bankwire' do
  let(:new_payout_bankwire){
    MangoPay::PayOut::BankWire.create({
      AuthorId: new_payin_card_web['CreditedUserId'],
      DebitedFunds: { Currency: 'EUR', Amount: 500 },
      Fees: { Currency: 'EUR', Amount: 0 },
      DebitedWalletId: new_payin_card_web['CreditedWalletId'],
      BankAccountId: new_iban_bank_detail['Id'],
      Communication: 'This is a test',
      Tag: 'Test Bank Wire'
    })
  }
end

shared_context 'transfer' do
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

shared_context 'card_registration' do
  let(:new_card_registration) {
    MangoPay::CardRegistration.create({
      UserId: new_natural_user['Id'],
      Currency: 'EUR',
      Tag: 'Test Card Registration'
    })
  }
end
