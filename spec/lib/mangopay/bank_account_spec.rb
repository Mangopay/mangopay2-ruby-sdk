require_relative '../../spec_helper'

describe MangoPay::BankAccount do
  include_context 'bank_accounts'

  describe 'CREATE' do
    it 'creates a new bank detail' do
      expect(new_bank_account['Id']).not_to be_nil
    end
  end

  describe 'FETCH' do

    it 'fetches all the bank details' do
      bank_details = MangoPay::BankAccount.fetch(new_bank_account['UserId'])
      expect(bank_details).to be_kind_of(Array)
      expect(bank_details[0]['Id']).to eq(new_bank_account['Id'])
    end

    it 'fetches one bank detail' do
      bank_detail = MangoPay::BankAccount.fetch(new_bank_account['UserId'], new_bank_account['Id'])
      expect(bank_detail['Id']).to eq(new_bank_account['Id'])
    end
  end
end
