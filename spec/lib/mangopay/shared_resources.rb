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
      'Name' => 'What a nice name'
    })
  }

  let(:new_client) {
    MangoPay::Client.create({
      'ClientID' => client_id,
      'Name' => 'What a nice name'
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
    MangoPay::BankDetail.create(new_natural_user['Id'], {
      Type: 'IBAN',
      OwnerName: 'John',
      OwnerAddress: 'Here',
      IBAN: 'FR76 1790 6000 3200 0833 5232 973',
      BIC: 'AGRIFRPP879',
      Tag: 'Test Time'
    })
  }
end

shared_context 'cards' do
  let(:new_web_card) {
    card = MangoPay::PayIn::Card::Web.create({
      AuthorId: new_natural_user['Id'],
      CreditedUserId: new_wallet['Owners'][0],
      DebitedFunds: { Currency: 'EUR', Amount: 1000 },
      Fees: { Currency: 'EUR', Amount: 0 },
      CreditedWalletId: new_wallet['Id'],
      ReturnURL: MangoPay.configuration.root_url,
      CardType: 'CB_VISA_MASTERCARD',
      Culture: 'FR',
      Tag: 'Test Card'
    })
    visit(card['RedirectURL'])
    fill_in('number', with: '4970100000000154')
    fill_in('cvv', with: '123')
    click_button('paybutton')
    card = MangoPay::PayIn.fetch(card['Id'])
    while card["Status"] == 'CREATED' do
      card = MangoPay::PayIn.fetch(card['Id'])
    end
    card
  }
end

shared_context 'bank_wires' do
  let(:new_bank_wire){
    # TODO: Once the issue with the CreditedWalletID being uppercased is solved
    # change DebitedWalletId: new_web_card['CreditedWalletID'] to
    # DebitedWalletId: new_web_card['CreditedWalletId']
    MangoPay::PayOut::BankWire.create({
      AuthorId: new_web_card['CreditedUserId'],
      DebitedFunds: { Currency: 'EUR', Amount: 500 },
      Fees: { Currency: 'EUR', Amount: 0 },
      DebitedWalletId: new_web_card['CreditedWalletID'],
      BankDetailsId: new_iban_bank_detail['Id'],
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
      ReturnURL: MangoPay.configuration.root_url,
      CardType: 'CB_VISA_MASTERCARD',
      Culture: 'FR',
      Tag: 'Test Card'
    })
    visit(card['RedirectURL'])
    fill_in('number', with: '4970100000000154')
    fill_in('cvv', with: '123')
    click_button('paybutton')
    card = MangoPay::PayIn.fetch(card['Id'])
    while card["Status"] == 'CREATED' do
      card = MangoPay::PayIn.fetch(card['Id'])
    end
    card
  }

  # TODO: Once the issue with the CreditedWalletID being uppercased is solved
  # change DebitedWalletId: new_web_card['CreditedWalletID'] to
  # DebitedWalletId: new_web_card['CreditedWalletId']
  let(:new_transfer) {
    MangoPay::Transfer.create({
      AuthorId: web_card_contribution['CreditedUserId'],
      CreditedUserId: credited_wallet['Owners'][0],
      DebitedFunds: { Currency: 'EUR', Amount: 500},
      Fees: { Currency: 'EUR', Amout: 0},
      DebitedWalletId: web_card_contribution['CreditedWalletID'],
      CreditedWalletId: credited_wallet['Id'],
      Tag: 'Test Transfer'
    })
  }
end
