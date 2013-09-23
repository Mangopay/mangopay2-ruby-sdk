require_relative '../../spec_helper'

describe MangoPay::User do
  include_context 'users'

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
end
