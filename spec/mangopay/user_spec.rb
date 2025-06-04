describe MangoPay::User do
  include_context 'users'
  include_context 'payins'
  include_context 'payouts'
  include_context 'wallets'
  include_context 'kyc_documents'

  describe 'CREATE' do
    it 'creates a new natural user' do
      expect(new_natural_user["FirstName"]).to eq('John')
    end

    it 'creates a new legal user' do
      expect(new_legal_user["LegalRepresentativeFirstName"]).to eq('John')
    end

    it 'creates a new legal user' do
      expect(new_legal_user["CompanyNumber"]).to eq('LU123456789')
    end
  end

  describe 'CREATE SCA' do
    it 'creates a new SCA natural user payer' do
      user = new_natural_user_sca_payer
      expect(user["FirstName"]).to eq('Alex')
      expect(user["UserCategory"]).to eq('PAYER')
      expect(user["UserStatus"]).to eq('ACTIVE')
    end

    it 'creates a new SCA natural user owner' do
      user = new_natural_user_sca_owner
      expect(user["FirstName"]).to eq('Alex')
      expect(user["UserCategory"]).to eq('OWNER')
      expect(user["UserStatus"]).to eq('PENDING_USER_ACTION')
      expect(user["PendingUserAction"]["RedirectUrl"]).not_to be_nil
    end

    it 'creates a new SCA legal user payer' do
      user = new_legal_user_sca_payer
      expect(user["Name"]).to eq('Alex Smith')
      expect(user["UserCategory"]).to eq('PAYER')
      expect(user["UserStatus"]).to eq('ACTIVE')
    end

    it 'creates a new SCA legal user owner' do
      user = new_legal_user_sca_owner
      expect(user["Name"]).to eq('Alex Smith')
      expect(user["UserCategory"]).to eq('OWNER')
      expect(user["UserStatus"]).to eq('PENDING_USER_ACTION')
      expect(user["PendingUserAction"]["RedirectUrl"]).not_to be_nil
    end
  end

  describe 'UPDATE' do
    it 'updates a natural user' do
      updated_user = MangoPay::NaturalUser.update(new_natural_user['Id'] ,{
        FirstName: 'Jack'
      })
      expect(updated_user['FirstName']).to eq('Jack')
    end

    it 'updates a legal user' do
      updated_user = MangoPay::LegalUser.update(new_legal_user['Id'], {
        LegalRepresentativeFirstName: 'Jack'
      })
      expect(updated_user['LegalRepresentativeFirstName']).to eq('Jack')
    end

    it 'updates a natural user terms and conditions accepted' do
      updated_user = MangoPay::NaturalUser.update(new_natural_user['Id'] ,{
        TermsAndConditionsAccepted: true
      })
      expect(updated_user['TermsAndConditionsAccepted']).to eq(true)
    end

    it 'updates a legal user terms and conditions accepted' do
      updated_user = MangoPay::LegalUser.update(new_legal_user['Id'], {
        TermsAndConditionsAccepted: true
      })
      expect(updated_user['TermsAndConditionsAccepted']).to eq(true)
    end
  end

  describe 'UPDATE SCA' do
    it 'updates a SCA natural user' do
      user = new_natural_user_sca_owner
      updated_user = MangoPay::NaturalUserSca.update(user['Id'] ,{
        FirstName: 'Jack'
      })
      fetched = MangoPay::NaturalUserSca.fetch(user['Id'])
      expect(updated_user['FirstName']).to eq('Jack')
      expect(updated_user['FirstName']).to eq(fetched['FirstName'])
    end

    it 'updates a SCA legal user' do
      user = new_legal_user_sca_owner
      legal_representative = user['LegalRepresentative']
      legal_representative['FirstName'] = 'Jack'
      updated_user = MangoPay::LegalUserSca.update(user['Id'] ,{
        LegalRepresentative: legal_representative
      })
      fetched = MangoPay::LegalUserSca.fetch(user['Id'])
      expect(updated_user['LegalRepresentative']['FirstName']).to eq('Jack')
      expect(updated_user['LegalRepresentative']['FirstName']).to eq(fetched['LegalRepresentative']['FirstName'])
    end
  end

  describe 'CATEGORIZE SCA' do
    it 'transitions SCA natural user Payer to Owner' do
      user = new_natural_user_sca_payer
      categorized = MangoPay::NaturalUserSca.categorize(user['Id'] ,{
        "UserCategory": "OWNER",
        "TermsAndConditionsAccepted": true,
        "Birthday": 652117514,
        "Nationality": "FR",
        "CountryOfResidence": "FR"
      })
      fetched = MangoPay::NaturalUserSca.fetch(user['Id'])
      expect(user['UserCategory']).to eq('PAYER')
      expect(categorized['UserCategory']).to eq('OWNER')
      expect(fetched['UserCategory']).to eq('OWNER')
    end

    it 'transitions SCA legal user Payer to Owner' do
      user = new_legal_user_sca_payer
      categorized = MangoPay::LegalUserSca.categorize(user['Id'] ,{
        "UserCategory": "OWNER",
        "TermsAndConditionsAccepted": true,
        "LegalRepresentative": {
          "Birthday": 652117514,
          "Nationality": "FR",
          "CountryOfResidence": "FR",
          "Email": "alex.smith@example.com"
        },
        "HeadquartersAddress": {
          "AddressLine1": "3 rue de la Cité",
          "AddressLine2": "Appartement 7",
          "City": "Paris",
          "Region": "Île-de-France",
          "PostalCode": "75004",
          "Country": "FR"
        },
        "CompanyNumber": "123456789"
      })
      fetched = MangoPay::LegalUserSca.fetch(user['Id'])
      expect(user['UserCategory']).to eq('PAYER')
      expect(categorized['UserCategory']).to eq('OWNER')
      expect(fetched['UserCategory']).to eq('OWNER')
    end
  end

  describe 'ENROLL SCA' do
    it 'enrolls user' do
      user = new_natural_user
      enrollment_result = MangoPay::User.enroll_sca(user['Id'])
      expect(enrollment_result["PendingUserAction"]["RedirectUrl"]).not_to be_nil
    end
  end

  describe 'FETCH' do
    it 'fetches all the users' do
      users = MangoPay::User.fetch()
      expect(users).to be_kind_of(Array)
      expect(users).not_to be_empty
    end

    it 'fetches a legal user using the User module' do
      legal_user = MangoPay::User.fetch(new_legal_user['Id'])
      expect(legal_user['Id']).to eq(new_legal_user['Id'])
    end

    it 'fetches a natural user using the User module' do
      natural_user = MangoPay::User.fetch(new_natural_user['Id'])
      expect(natural_user['Id']).to eq(new_natural_user['Id'])
    end

    it 'fetches a legal user' do
      user = MangoPay::LegalUser.fetch(new_legal_user['Id'])
      expect(user['Id']).to eq(new_legal_user['Id'])
    end

    it 'fetches a natural user' do
      user = MangoPay::NaturalUser.fetch(new_natural_user['Id'])
      expect(user['Id']).to eq(new_natural_user['Id'])
    end
  end

  describe 'FETCH SCA' do
    it 'fetches a SCA legal user using the User module' do
      user = new_legal_user_sca_owner
      fetched = MangoPay::User.fetch_sca(new_legal_user_sca_owner['Id'])
      expect(fetched['Id']).to eq(user['Id'])
    end

    it 'fetches a SCA natural user using the User module' do
      user = new_natural_user_sca_owner
      fetched = MangoPay::User.fetch_sca(user['Id'])
      expect(fetched['Id']).to eq(user['Id'])
    end

    it 'fetches a SCA legal user' do
      user = new_legal_user_sca_owner
      fetched = MangoPay::LegalUserSca.fetch(user['Id'])
      expect(fetched['Id']).to eq(user['Id'])
    end

    it 'fetches a SCA natural user' do
      user = new_natural_user_sca_owner
      fetched = MangoPay::NaturalUserSca.fetch(user['Id'])
      expect(fetched['Id']).to eq(user['Id'])
    end
  end

  describe 'FETCH TRANSACTIONS' do
    it 'fetches empty list of transactions if no transactions done' do
      transactions = MangoPay::User.transactions(new_natural_user['Id'])
      expect(transactions).to be_kind_of(Array)
      expect(transactions).to be_empty
    end

    it 'fetches list with single transaction after payin done' do
      payin = new_payin_card_direct
      transactions = MangoPay::User.transactions(new_natural_user['Id'])
      expect(transactions).to be_kind_of(Array)
      expect(transactions.count).to eq 1
      expect(transactions.first['Id']).to eq payin['Id']
    end

    it 'fetches list with two transactions after payin and payout done' do
      payin = new_payin_card_direct
      payout = create_new_payout_bankwire(payin)
      # wait for the transactions to be created
      sleep(2)
      transactions = MangoPay::User.transactions(new_natural_user['Id'])

      expect(transactions).to be_kind_of(Array)
      expect(transactions.count).to eq 2

      transactions_ids = transactions.map {|t| t['Id']}
      expect(transactions_ids).to include payin['Id']
      expect(transactions_ids).to include payout['Id']
    end

    it 'fetches transactions sca' do
      begin
        MangoPay::User.transactions(new_natural_user['Id'], {'ScaContext': 'USER_PRESENT'})
      rescue MangoPay::ResponseError => ex
        expect(ex.details['RedirectUrl']).not_to be_nil
      end
    end
  end

  describe 'FETCH WALLETS' do
    it 'fetches empty list of wallets if no wallets created' do
      wallets = MangoPay::User.wallets(new_natural_user['Id'])
      expect(wallets).to be_kind_of(Array)
      expect(wallets).to be_empty
    end

    it 'fetches list with single wallet after created' do
      wallet = new_wallet
      wallets = MangoPay::User.wallets(new_natural_user['Id'])
      expect(wallets).to be_kind_of(Array)
      expect(wallets.count).to eq 1
      expect(wallets.first['Id']).to eq wallet['Id']
    end

    it 'fetches wallets sca' do
      begin
        MangoPay::User.wallets(new_natural_user['Id'], {'ScaContext': 'USER_PRESENT'})
      rescue MangoPay::ResponseError => ex
        expect(ex.details['RedirectUrl']).not_to be_nil
      end
    end
  end

  describe 'FETCH CARDS' do
    it 'fetches empty list of cards if no cards created' do
      cards = MangoPay::User.cards(new_natural_user['Id'])
      expect(cards).to be_kind_of(Array)
      expect(cards).to be_empty
    end

    it 'fetches list with single card after created' do
      card = new_card_registration_completed
      cards = MangoPay::User.cards(new_natural_user['Id'])
      expect(cards).to be_kind_of(Array)
      expect(cards.count).to eq 1
      expect(cards.first['Id']).to eq card['CardId']
    end

    it 'fetches card details' do
        card = new_card_registration_completed
        fetched = MangoPay::Card.fetch(card['CardId'])

        expect(fetched['Id']).not_to be_nil
        expect(fetched['UserId']).to eq(new_natural_user["Id"])
        expect(fetched['Currency']).to eq('EUR')
      end
  end

  describe 'FETCH BANK ACCOUNTS' do
    it 'fetches empty list of bank accounts if no bank_accounts created' do
      bank_accounts = MangoPay::User.bank_accounts(new_natural_user['Id'])
      expect(bank_accounts).to be_kind_of(Array)
      expect(bank_accounts).to be_empty
    end

    it 'fetches list with single bank_account after created' do
      bank_account = new_bank_account
      bank_accounts = MangoPay::User.bank_accounts(new_natural_user['Id'])
      expect(bank_accounts).to be_kind_of(Array)
      expect(bank_accounts.count).to eq 1
      expect(bank_accounts.first['Id']).to eq bank_account['Id']
    end
  end

  describe 'FETCH EMONEY' do
    it 'fetches emoney for the user for year 2019' do
      emoney = MangoPay::User.emoney(new_natural_user['Id'], 2019)
      expect(emoney['UserId']).to eq new_natural_user['Id']
      expect(emoney['CreditedEMoney']['Amount']).to eq 0
      expect(emoney['CreditedEMoney']['Currency']).to eq 'EUR'
      expect(emoney['DebitedEMoney']['Amount']).to eq 0
      expect(emoney['DebitedEMoney']['Currency']).to eq 'EUR'
    end

    it 'fetches emoney for the user for date 08/2019' do
      emoney = MangoPay::User.emoney(new_natural_user['Id'], 2019, 8)
      expect(emoney['UserId']).to eq new_natural_user['Id']
      expect(emoney['CreditedEMoney']['Amount']).to eq 0
      expect(emoney['CreditedEMoney']['Currency']).to eq 'EUR'
      expect(emoney['DebitedEMoney']['Amount']).to eq 0
      expect(emoney['DebitedEMoney']['Currency']).to eq 'EUR'
    end
  end

  describe 'FETCH Kyc Document' do
    it 'fetches empty list of kyc documents if no kyc document created' do
      documents = MangoPay::User.kyc_documents(new_natural_user['Id'])
      expect(documents).to be_kind_of(Array)
      expect(documents).to be_empty
    end

    it 'fetches list with single kyc document after created' do
      document = new_document
      documents = MangoPay::User.kyc_documents(document['UserId'])
      expect(documents).to be_kind_of(Array)
      expect(documents.count).to eq 1
      expect(documents.first['Id']).to eq document['Id']
    end
  end

  #describe 'CREATE UBO DECLARATION' do
  #  it 'creates a UBO declaration' do
  #    legal_user = new_legal_user
  #    natural_user = define_new_natural_user
  #    natural_user['Capacity'] = 'DECLARATIVE'
  #    natural_user = MangoPay::NaturalUser.create(natural_user)
  #    ubo_declaration = MangoPay::LegalUser.create_ubo_declaration(legal_user['Id'])

  #   expect(ubo_declaration).not_to be_nil
  #    expect(ubo_declaration['Status']).to eq 'CREATED'
  #    expect(ubo_declaration['UserId']).to eq legal_user['Id']
  #    expect(ubo_declaration['DeclaredUBOs'][0]['UserId']).to eq natural_user['Id']
  #  end
  #end

  describe 'FETCH Pre-Authorizations' do
    it "fetches list of user's pre-authorizations belonging" do
      legal_user = new_legal_user
      pre_authorizations = MangoPay::User.pre_authorizations(legal_user['Id'])
      expect(pre_authorizations).to be_an(Array)
    end
  end

=begin
  describe 'FETCH Block Status' do
    it "fetches user's block status" do
      legal_user = new_legal_user
      block_status = MangoPay::User.block_status(legal_user['Id'])
      expect(block_status).to_not be_nil
    end
  end
=end

  describe 'CLOSE' do
    it 'closes a natural user' do
      new_user = create_new_natural_user
      MangoPay::NaturalUser.close(new_user['Id'])
      closed = MangoPay::User.fetch(new_user['Id'])
      expect(closed['UserStatus']).to eq('CLOSED')
    end

    it 'closes a legal user' do
      new_user = new_legal_user
      MangoPay::LegalUser.close(new_user['Id'])
      closed = MangoPay::User.fetch(new_user['Id'])
      expect(closed['UserStatus']).to eq('CLOSED')
    end
  end

  describe 'Validate User Data Format' do
    it 'validates successfully' do
      validation = {
        "CompanyNumber": {
          "CompanyNumber": "AB123456",
          "CountryCode": "IT"
        }
      }
      result = MangoPay::User.validate_data_format(validation)
      expect(result['CompanyNumber']).not_to be_nil
    end

    it 'validates with error' do
      validation = {
        "CompanyNumber": {
          "CompanyNumber": "123"
        }
      }
      expect { MangoPay::User.validate_data_format(validation) }.to raise_error { |err|
        expect(err).to be_a MangoPay::ResponseError
        expect(err.code).to eq '400'
        expect(err.type).to eq 'param_error'
      }
    end
  end
end
