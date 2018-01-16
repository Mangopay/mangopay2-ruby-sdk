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
      transactions = MangoPay::User.transactions(new_natural_user['Id'])

      expect(transactions).to be_kind_of(Array)
      expect(transactions.count).to eq 2

      transactions_ids = transactions.map {|t| t['Id']}
      expect(transactions_ids).to include payin['Id']
      expect(transactions_ids).to include payout['Id']
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
        expect(fetched['Id'].to_i).to be > 0
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
    it 'fetches emoney for the user' do
      emoney = MangoPay::User.emoney(new_natural_user['Id'])
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

  describe 'CREATE UBO DECLARATION' do
    it 'creates a UBO declaration' do
      legal_user = new_legal_user
      natural_user = define_new_natural_user
      natural_user['Capacity'] = 'DECLARATIVE'
      natural_user = MangoPay::NaturalUser.create(natural_user)
      ubo_declaration = {
        DeclaredUBOs: [natural_user['Id']]
      }
      ubo_declaration = MangoPay::LegalUser.create_ubo_declaration(legal_user['Id'], ubo_declaration)

      expect(ubo_declaration).not_to be_nil
      expect(ubo_declaration['Status']).to eq 'CREATED'
      expect(ubo_declaration['UserId']).to eq legal_user['Id']
      expect(ubo_declaration['DeclaredUBOs'][0]['UserId']).to eq natural_user['Id']
    end
  end
end
