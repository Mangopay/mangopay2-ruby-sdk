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
    MangoPay::PayIn::Card::Web.create({
      AuthorId: new_natural_user['Id'],
      CreditedUserId: new_wallet['Owners'][0],
      DebitedFunds: { Currency: 'EUR', Amount: 1000 },
      Fees: { Currency: 'EUR', Amount: 0},
      CreditedWalletId: new_wallet['Id'],
      ReturnURL: 'http://dev.leetchi.com',
      CardType: 'CB_VISA_MASTERCARD',
      Culture: 'FR',
      Tag: 'Test Card'
    })
  }
end

shared_context 'bank_wires' do
  let(:new_bank_wire){
    MangoPay::PayOut::BankWire.create({
      AuthorId: new_wallet['Owners'][0],
      DebitedFunds: { Currency: 'EUR', Amount: 500 },
      Fees: { Currency: 'EUR', Amount: 0 },
      DebitedWalletId: new_wallet['Id'],
      BankDetailsId: new_iban_bank_detail['Id'],
      Communication: 'This is a test',
      Tag: 'Test Bank Wire'
    })
  }
end
