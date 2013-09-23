require_relative '../../spec_helper'

describe 'FETCH WITH FILTERS' do
  include_context 'users'
  include_context 'bank_accounts'

  describe 'FETCH USERS' do

    it 'returns single hash when called with id' do
      id = new_natural_user['Id']
      res = MangoPay::User.fetch(id)
      expect(res).to be_kind_of Hash
      expect(res['Id']).to eq id
    end

    it 'returns list of hashes with default pagination when called with no param' do
      res = MangoPay::User.fetch()
      expect(res).to be_kind_of Array
      expect(res.count).to eq 10
    end

    it 'returns list of hashes with default pagination when called with empty filters' do
      res = MangoPay::User.fetch(filters = {})
      expect(res).to be_kind_of Array
      expect(res.count).to eq 10
      expect(filters['total_items']).to be > 0
      expect(filters['total_pages']).to be > 0
    end

    it 'returns list of hashes with correct pagination when called with pagination filters' do
      res = MangoPay::User.fetch(filters = {page:2, per_page:3})
      expect(res).to be_kind_of Array
      expect(res.count).to eq 3 # 3 items per page as requested
      expect(filters['total_items']).to be > 0
      expect(filters['total_pages']).to be > 0
    end
  end

  describe 'FETCH BANK ACCOUNTS OF USER' do

    it 'returns single hash when called with user id and account id' do
      bank_account = new_bank_account
      res = MangoPay::BankAccount.fetch(bank_account['UserId'], bank_account['Id'])
      expect(res).to be_kind_of Hash
      expect(res['Id']).to eq bank_account['Id']
    end

    it 'returns list of hashes with default pagination when called with user id only' do
      bank_account = new_bank_account
      res = MangoPay::BankAccount.fetch(bank_account['UserId'])
      expect(res).to be_kind_of Array
      expect(res.count).to eq 1 # not enough items to fill-in whole page
    end

    it 'returns list of hashes with default pagination when called with empty filters' do
      bank_account = new_bank_account
      res = MangoPay::BankAccount.fetch(bank_account['UserId'], filters = {})
      expect(res).to be_kind_of Array
      expect(res.count).to eq 1 # not enough items to fill-in whole page
      expect(filters['total_items']).to eq 1
      expect(filters['total_pages']).to eq 1
    end
  end

end
