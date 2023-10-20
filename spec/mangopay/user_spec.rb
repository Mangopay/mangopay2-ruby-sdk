describe MangoPay::User do
  include_context 'users'
  include_context 'payins'
  include_context 'payouts'
  include_context 'wallets'
  include_context 'kyc_documents'

  let(:natural_user) { new_natural_user }
  let(:legal_user) { new_legal_user }

  describe 'CREATE' do
    it 'creates a new natural user' do
      expect(natural_user["FirstName"]).to eq('John')
    end

    it 'creates a new legal user' do
      expect(legal_user["LegalRepresentativeFirstName"]).to eq('John')
    end

    it 'creates a new legal user' do
      expect(legal_user["CompanyNumber"]).to eq('LU123456789')
    end

    context 'when snakify_response_keys is true' do
      include_context 'snakify_response_keys'
        it 'creates a new natural user' do
          expect(natural_user["first_name"]).to eq('John')
        end

        it 'creates a new legal user' do
          expect(legal_user["legal_representative_first_name"]).to eq('John')
        end

        it 'creates a new legal user' do
          expect(legal_user["company_number"]).to eq('LU123456789')
        end
      end
    end

  describe 'UPDATE' do
    it 'updates a natural user' do
      updated_user = MangoPay::NaturalUser.update(natural_user['Id'] ,{
        FirstName: 'Jack'
      })
      expect(updated_user['FirstName']).to eq('Jack')
    end

    it 'updates a legal user' do
      updated_user = MangoPay::LegalUser.update(legal_user['Id'], {
        LegalRepresentativeFirstName: 'Jack'
      })
      expect(updated_user['LegalRepresentativeFirstName']).to eq('Jack')
    end

    it 'updates a natural user terms and conditions accepted' do
      updated_user = MangoPay::NaturalUser.update(natural_user['Id'] ,{
        TermsAndConditionsAccepted: true
      })
      expect(updated_user['TermsAndConditionsAccepted']).to eq(true)
    end

    it 'updates a legal user terms and conditions accepted' do
      updated_user = MangoPay::LegalUser.update(legal_user['Id'], {
        TermsAndConditionsAccepted: true
      })
      expect(updated_user['TermsAndConditionsAccepted']).to eq(true)
    end

    context 'when snakify_response_keys is true' do
      include_context 'snakify_response_keys'
        it 'updates a natural user' do
          updated_user = MangoPay::NaturalUser.update(natural_user['id'] ,{
            FirstName: 'Jack'
          })
          expect(updated_user['first_name']).to eq('Jack')
        end

        it 'updates a legal user' do
          updated_user = MangoPay::LegalUser.update(legal_user['id'], {
            LegalRepresentativeFirstName: 'Jack'
          })
          expect(updated_user['legal_representative_first_name']).to eq('Jack')
        end

        it 'updates a natural user terms and conditions accepted' do
          updated_user = MangoPay::NaturalUser.update(natural_user['id'] ,{
            TermsAndConditionsAccepted: true
          })
          expect(updated_user['terms_and_conditions_accepted']).to eq(true)
        end

        it 'updates a legal user terms and conditions accepted' do
          updated_user = MangoPay::LegalUser.update(legal_user['id'], {
            TermsAndConditionsAccepted: true
          })
          expect(updated_user['terms_and_conditions_accepted']).to eq(true)
        end
      end
    end

  describe 'FETCH' do
    it 'fetches all the users' do
      users = MangoPay::User.fetch()
      expect(users).to be_kind_of(Array)
      expect(users).not_to be_empty
    end

    it 'fetches a legal user using the User module' do
      user = MangoPay::User.fetch(legal_user['Id'])
      expect(user['Id']).to eq(legal_user['Id'])
    end

    it 'fetches a natural user using the User module' do
      user = MangoPay::User.fetch(natural_user['Id'])
      expect(user['Id']).to eq(natural_user['Id'])
    end

    it 'fetches a legal user' do
      user = MangoPay::LegalUser.fetch(legal_user['Id'])
      expect(user['Id']).to eq(legal_user['Id'])
    end

    it 'fetches a natural user' do
      user = MangoPay::NaturalUser.fetch(natural_user['Id'])
      expect(user['Id']).to eq(natural_user['Id'])
    end

    context 'when snakify_response_keys is true' do
      include_context 'snakify_response_keys'
        it 'fetches all the users' do
          users = MangoPay::User.fetch()
          expect(users).to be_kind_of(Array)
          expect(users).not_to be_empty
        end

        it 'fetches a legal user using the User module' do
          user = MangoPay::User.fetch(legal_user['id'])
          expect(user['id']).to eq(legal_user['id'])
        end

        it 'fetches a natural user using the User module' do
          user = MangoPay::User.fetch(natural_user['id'])
          expect(user['id']).to eq(natural_user['id'])
        end

        it 'fetches a legal user' do
          user = MangoPay::LegalUser.fetch(legal_user['id'])
          expect(user['id']).to eq(legal_user['id'])
        end

        it 'fetches a natural user' do
          user = MangoPay::NaturalUser.fetch(natural_user['id'])
          expect(user['id']).to eq(natural_user['id'])
        end
      end
    end

  describe 'FETCH TRANSACTIONS' do
    it 'fetches empty list of transactions if no transactions done' do
      transactions = MangoPay::User.transactions(natural_user['Id'])
      expect(transactions).to be_kind_of(Array)
      expect(transactions).to be_empty
    end

    it 'fetches list with single transaction after payin done' do
      payin = new_payin_card_direct
      transactions = MangoPay::User.transactions(natural_user['Id'])
      expect(transactions).to be_kind_of(Array)
      expect(transactions.count).to eq 1
      expect(transactions.first['Id']).to eq payin['Id']
    end

    # it 'fetches list with two transactions after payin and payout done' do
    #   payin = new_payin_card_direct
    #   payout = create_new_payout_bankwire(payin)
    #   transactions = MangoPay::User.transactions(natural_user['Id'])
    #
    #   expect(transactions).to be_kind_of(Array)
    #   expect(transactions.count).to eq 2
    #
    #   transactions_ids = transactions.map {|t| t['Id']}
    #   expect(transactions_ids).to include payin['Id']
    #   expect(transactions_ids).to include payout['Id']
    # end

    context 'when snakify_response_keys is true' do
      include_context 'snakify_response_keys'
        it 'fetches empty list of transactions if no transactions done' do
          transactions = MangoPay::User.transactions(natural_user['id'])
          expect(transactions).to be_kind_of(Array)
          expect(transactions).to be_empty
        end

        it 'fetches list with single transaction after payin done' do
          payin = new_payin_card_direct2
          transactions = MangoPay::User.transactions(natural_user['id'])
          expect(transactions).to be_kind_of(Array)
          expect(transactions.count).to eq 1
          expect(transactions.first['id']).to eq payin['id']
        end

        # it 'fetches list with two transactions after payin and payout done' do
        #   payin = new_payin_card_direct2
        #   payout = create_new_payout_bankwire2(payin)
        #
        #   transactions = MangoPay::User.transactions(natural_user['id'])
        #
        #   expect(transactions).to be_kind_of(Array)
        #   expect(transactions.count).to eq 2
        #
        #   transactions_ids = transactions.map {|t| t['id']}
        #   expect(transactions_ids).to include payin['id']
        #   expect(transactions_ids).to include payout['id']
        # end
      end
    end

  describe 'FETCH WALLETS' do
    it 'fetches empty list of wallets if no wallets created' do
      wallets = MangoPay::User.wallets(natural_user['Id'])
      expect(wallets).to be_kind_of(Array)
      expect(wallets).to be_empty
    end

    it 'fetches list with single wallet after created' do
      wallet = new_wallet
      wallets = MangoPay::User.wallets(natural_user['Id'])
      expect(wallets).to be_kind_of(Array)
      expect(wallets.count).to eq 1
      expect(wallets.first['Id']).to eq wallet['Id']
    end

    context 'when snakify_response_keys is true' do
      include_context 'snakify_response_keys'
      it 'fetches empty list of wallets if no wallets created' do
        wallets = MangoPay::User.wallets(natural_user['id'])
        expect(wallets).to be_kind_of(Array)
        expect(wallets).to be_empty
      end

      it 'fetches list with single wallet after created' do
        wallet = new_wallet2
        wallets = MangoPay::User.wallets(natural_user['id'])
        expect(wallets).to be_kind_of(Array)
        expect(wallets.count).to eq 1
        expect(wallets.first['id']).to eq wallet['id']
      end
    end
  end

  describe 'FETCH CARDS' do
    it 'fetches empty list of cards if no cards created' do
      cards = MangoPay::User.cards(natural_user['Id'])
      expect(cards).to be_kind_of(Array)
      expect(cards).to be_empty
    end

    it 'fetches list with single card after created' do
      card = new_card_registration_completed
      cards = MangoPay::User.cards(natural_user['Id'])
      expect(cards).to be_kind_of(Array)
      expect(cards.count).to eq 1
      expect(cards.first['Id']).to eq card['CardId']
    end

    it 'fetches card details' do
        card = new_card_registration_completed
        fetched = MangoPay::Card.fetch(card['CardId'])

        expect(fetched['Id']).not_to be_nil
        expect(fetched['Id'].to_i).to be > 0
        expect(fetched['UserId']).to eq(natural_user['Id'])
        expect(fetched['Currency']).to eq('EUR')
    end

    context 'when snakify_response_keys is true' do
      include_context 'snakify_response_keys'
      it 'fetches empty list of cards if no cards created' do
        cards = MangoPay::User.cards(natural_user['id'])
        expect(cards).to be_kind_of(Array)
        expect(cards).to be_empty
      end

      it 'fetches list with single card after created' do
        card = new_card_registration_completed2
        cards = MangoPay::User.cards(natural_user['id'])
        expect(cards).to be_kind_of(Array)
        expect(cards.count).to eq 1
        expect(cards.first['id']).to eq card['card_id']
      end

      it 'fetches card details' do
        card = new_card_registration_completed2
        fetched = MangoPay::Card.fetch(card['card_id'])

        expect(fetched['id']).not_to be_nil
        expect(fetched['id'].to_i).to be > 0
        expect(fetched['user_id']).to eq(natural_user['id'])
        expect(fetched['currency']).to eq('EUR')
      end
    end
  end

  describe 'FETCH BANK ACCOUNTS' do
    it 'fetches empty list of bank accounts if no bank_accounts created' do
      bank_accounts = MangoPay::User.bank_accounts(natural_user['Id'])
      expect(bank_accounts).to be_kind_of(Array)
      expect(bank_accounts).to be_empty
    end

    it 'fetches list with single bank_account after created' do
      bank_account = new_bank_account
      bank_accounts = MangoPay::User.bank_accounts(natural_user['Id'])
      expect(bank_accounts).to be_kind_of(Array)
      expect(bank_accounts.count).to eq 1
      expect(bank_accounts.first['Id']).to eq bank_account['Id']
    end

    context 'when snakify_response_keys is true' do
      include_context 'snakify_response_keys'
      it 'fetches empty list of bank accounts if no bank_accounts created' do
        bank_accounts = MangoPay::User.bank_accounts(natural_user['id'])
        expect(bank_accounts).to be_kind_of(Array)
        expect(bank_accounts).to be_empty
      end

      it 'fetches list with single bank_account after created' do
        bank_account = new_bank_account2
        bank_accounts = MangoPay::User.bank_accounts(natural_user['id'])
        expect(bank_accounts).to be_kind_of(Array)
        expect(bank_accounts.count).to eq 1
        expect(bank_accounts.first['id']).to eq bank_account['id']
      end
    end
  end

  describe 'FETCH EMONEY' do
    it 'fetches emoney for the user for year 2019' do
      emoney = MangoPay::User.emoney(natural_user['Id'], 2019)
      expect(emoney['UserId']).to eq natural_user['Id']
      expect(emoney['CreditedEMoney']['Amount']).to eq 0
      expect(emoney['CreditedEMoney']['Currency']).to eq 'EUR'
      expect(emoney['DebitedEMoney']['Amount']).to eq 0
      expect(emoney['DebitedEMoney']['Currency']).to eq 'EUR'
    end

    it 'fetches emoney for the user for date 08/2019' do
      emoney = MangoPay::User.emoney(natural_user['Id'], 2019, 8)
      expect(emoney['UserId']).to eq natural_user['Id']
      expect(emoney['CreditedEMoney']['Amount']).to eq 0
      expect(emoney['CreditedEMoney']['Currency']).to eq 'EUR'
      expect(emoney['DebitedEMoney']['Amount']).to eq 0
      expect(emoney['DebitedEMoney']['Currency']).to eq 'EUR'
    end

    context 'when snakify_response_keys is true' do
      include_context 'snakify_response_keys'
      it 'fetches emoney for the user for year 2019' do
        emoney = MangoPay::User.emoney(natural_user['id'], 2019)
        expect(emoney['user_id']).to eq natural_user['id']
        expect(emoney['credited_e_money']['amount']).to eq 0
        expect(emoney['credited_e_money']['currency']).to eq 'EUR'
        expect(emoney['debited_e_money']['amount']).to eq 0
        expect(emoney['debited_e_money']['currency']).to eq 'EUR'
      end

      it 'fetches emoney for the user for date 08/2019' do
        emoney = MangoPay::User.emoney(natural_user['id'], 2019, 8)
        expect(emoney['user_id']).to eq natural_user['id']
        expect(emoney['credited_e_money']['amount']).to eq 0
        expect(emoney['credited_e_money']['currency']).to eq 'EUR'
        expect(emoney['debited_e_money']['amount']).to eq 0
        expect(emoney['debited_e_money']['currency']).to eq 'EUR'
      end
    end
  end

  describe 'FETCH Kyc Document' do
    it 'fetches empty list of kyc documents if no kyc document created' do
      documents = MangoPay::User.kyc_documents(natural_user['Id'])
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

    context 'when snakify_response_keys is true' do
      include_context 'snakify_response_keys'
      it 'fetches empty list of kyc documents if no kyc document created' do
        documents = MangoPay::User.kyc_documents(natural_user['id'])
        expect(documents).to be_kind_of(Array)
        expect(documents).to be_empty
      end

      it 'fetches list with single kyc document after created' do
        document = new_document2
        documents = MangoPay::User.kyc_documents(document['user_id'])
        expect(documents).to be_kind_of(Array)
        expect(documents.count).to eq 1
        expect(documents.first['id']).to eq document['id']
      end
    end
  end

  #describe 'CREATE UBO DECLARATION' do
  #  it 'creates a UBO declaration' do
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
      pre_authorizations = MangoPay::User.pre_authorizations(legal_user['Id'])
      expect(pre_authorizations).to be_an(Array)
    end

    context 'when snakify_response_keys is true' do
      include_context 'snakify_response_keys'
      it "fetches list of user's pre-authorizations belonging" do
        pre_authorizations = MangoPay::User.pre_authorizations(legal_user['id'])
        expect(pre_authorizations).to be_an(Array)
      end
    end
  end

=begin
  describe 'FETCH Block Status' do
    it "fetches user's block status" do
      user = legal_user
      block_status = MangoPay::User.block_status(legal_user['Id'])
      expect(block_status).to_not be_nil
    end
  end
=end
end
