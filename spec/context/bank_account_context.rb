require_relative 'user_context'
require_relative '../../lib/mangopay/model/entity/account/iban_bank_account'
require_relative '../../lib/mangopay/model/entity/account/us_bank_account'
require_relative '../../lib/mangopay/model/entity/account/ca_bank_account'
require_relative '../../lib/mangopay/model/entity/account/gb_bank_account'
require_relative '../../lib/mangopay/model/entity/account/other_bank_account'
require_relative '../../lib/mangopay/api/service/bank_accounts'

shared_context 'bank_account_context' do
  include_context 'user_context'

  IBAN_ACCOUNT_DATA ||= build_iban_account
  US_CHECKING_ACCOUNT_DATA ||= build_us_checking_account
  US_SAVINGS_ACCOUNT_DATA ||= build_us_savings_account
  CA_ACCOUNT_DATA ||= build_ca_account
  GB_ACCOUNT_DATA ||= build_gb_account
  OTHER_ACCOUNT_DATA ||= build_other_account
  IBAN_ACCOUNT_PERSISTED ||= persist_account IBAN_ACCOUNT_DATA
  US_CHECKING_ACCOUNT_PERSISTED ||= persist_account US_CHECKING_ACCOUNT_DATA
  US_SAVINGS_ACCOUNT_PERSISTED ||= persist_account US_SAVINGS_ACCOUNT_DATA
  CA_ACCOUNT_PERSISTED ||= persist_account CA_ACCOUNT_DATA
  GB_ACCOUNT_PERSISTED ||= persist_account GB_ACCOUNT_DATA
  OTHER_ACCOUNT_PERSISTED ||= persist_account OTHER_ACCOUNT_DATA

  let(:new_iban_account_persisted) { persist_account IBAN_ACCOUNT_DATA }
  let(:new_us_checking_account_persisted) { persist_account US_CHECKING_ACCOUNT_DATA }
  let(:new_us_savings_account_persisted) { persist_account US_SAVINGS_ACCOUNT_DATA }
  let(:new_ca_account_persisted) { persist_account CA_ACCOUNT_DATA }
  let(:new_gb_account_persisted) { persist_account GB_ACCOUNT_DATA }
  let(:new_other_account_persisted) { persist_account OTHER_ACCOUNT_DATA }
end

def persist_account(account)
  MangoApi::BankAccounts.create account
end

def build_iban_account
  account = MangoModel::IbanBankAccount.new
  add_user_details account
  account.iban = 'FR7630004000031234567890143'
  account.bic = 'CRLYFRPP'
  account
end

def build_us_account
  account = MangoModel::UsBankAccount.new
  add_user_details account
  account.account_number = '234234234234'
  account.aba = '234334789'
  account
end

def build_us_checking_account
  account = build_us_account
  account.deposit_account_type = MangoModel::DepositType::CHECKING
  account
end

def build_us_savings_account
  account = build_us_account
  account.deposit_account_type = MangoModel::DepositType::SAVINGS
  account
end

def build_ca_account
  account = MangoModel::CaBankAccount.new
  add_user_details account
  account.institution_number = '123'
  account.account_number = '234234234234'
  account.branch_code = '12345'
  account.bank_name = 'Mango Bank'
  account
end

def build_gb_account
  account = MangoModel::GbBankAccount.new
  add_user_details account
  account.sort_code = '200000'
  account.account_number = '63956474'
  account
end

def build_other_account
  account = MangoModel::OtherBankAccount.new
  add_user_details account
  account.bic = 'BINAADADXXX'
  account.account_number = '234234234234'
  account.country = MangoModel::CountryIso::FR
  account
end

def add_user_details(account)
  user = NATURAL_USER_PERSISTED
  account.user_id = user.id
  account.owner_name = user.first_name + ' ' + user.last_name
  account.owner_address = user.address
end

def its_the_same_iban(account1, account2)
  return false unless its_the_same_account(account1, account2)
  account1.iban == account2.iban\
    && account1.bic == account2.bic
end

def its_the_same_us(account1, account2)
  return false unless its_the_same_account(account1, account2)
  account1.account_number == account2.account_number\
    && account1.aba == account2.aba\
    && account1.deposit_account_type.eql?(account2.deposit_account_type)
end

def its_the_same_ca(account1, account2)
  return false unless its_the_same_account(account1, account2)
  account1.institution_number == account2.institution_number\
    && account1.account_number == account2.account_number\
    && account1.branch_code == account2.branch_code\
    && account1.bank_name == account2.bank_name
end

def its_the_same_gb(account1, account2)
  return false unless its_the_same_account(account1, account2)
  account1.sort_code == account2.sort_code\
    && account1.account_number == account2.account_number
end

def its_the_same_other(account1, account2)
  return false unless its_the_same_account(account1, account2)
  account1.bic == account2.bic\
    && account1.account_number == account2.account_number\
    && account1.country.eql?(account2.country)
end

def its_the_same_account(account1, account2)
  account1.user_id == account2.user_id\
    && account1.type.eql?(account2.type)\
    && account1.owner_name == account2.owner_name\
    && its_the_same_address(account1.owner_address, account2.owner_address)
end