require_relative '../../spec_helper'

describe MangoPay::User do
  include_context 'users'
  include_context 'payins'
  include_context 'payouts'
  include_context 'wallets'

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
  end

end
