require_relative '../../spec_helper'

describe MangoPay::BankDetail do
  include_context 'users'
  include_context 'bank_details'

  describe 'CREATE' do
    it 'creates a new bank detail' do
      expect(new_iban_bank_detail['Id']).not_to be_nil
    end
  end

  describe 'FETCH' do

    it 'fetches all the bank details' do
      bank_details = MangoPay::BankDetail.fetch(new_iban_bank_detail['UserId'])
      expect(bank_details).to be_kind_of(Array)
      expect(bank_details[0]['Id']).to eq(new_iban_bank_detail['Id'])
    end

    it 'fetches one bank detail' do
      bank_detail = MangoPay::BankDetail.fetch(new_iban_bank_detail['UserId'], new_iban_bank_detail['Id'])
      expect(bank_detail['Id']).to eq(new_iban_bank_detail['Id'])
    end
  end
end
