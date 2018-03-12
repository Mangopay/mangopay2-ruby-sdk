require_relative '../../lib/mangopay/model/entity/account/bank_account'
require_relative '../../spec/context/bank_account_context'
require_relative '../../lib/mangopay/api/service/bank_accounts'
require_relative '../../lib/mangopay/common/sort_direction'
require_relative '../../lib/mangopay/common/sort_field'

describe MangoApi::BankAccounts do
  include_context 'bank_account_context'

  describe '.create' do

    describe '#IBAN' do
      context 'given a valid object' do
        account = IBAN_ACCOUNT_PERSISTED

        it 'creates the IBAN bank account entity' do
          expect(account).to be_kind_of MangoModel::IbanBankAccount
          expect(account.id).not_to be_nil
          expect(its_the_same_iban(account, IBAN_ACCOUNT_PERSISTED)).to be_truthy
        end
      end
    end

    describe '#US' do

      describe '#Savings' do
        context 'given a valid object' do
          account = US_SAVINGS_ACCOUNT_PERSISTED

          it 'creates the US savings bank account entity' do
            expect(account).to be_kind_of MangoModel::UsBankAccount
            expect(account.id).not_to be_nil
            expect(its_the_same_us(account, US_SAVINGS_ACCOUNT_PERSISTED)).to be_truthy
          end
        end
      end

      describe '#Checking' do
        context 'given a valid object' do
          account = US_CHECKING_ACCOUNT_PERSISTED

          it 'creates the US checking bank account entity' do
            expect(account).to be_kind_of MangoModel::UsBankAccount
            expect(account.id).not_to be_nil
            expect(its_the_same_us(account, US_CHECKING_ACCOUNT_PERSISTED)).to be_truthy
          end
        end
      end
    end

    describe '#CA' do
      context 'given a valid object' do
        account = CA_ACCOUNT_PERSISTED

        it 'creates the CA bank account entity' do
          expect(account).to be_kind_of MangoModel::CaBankAccount
          expect(account.id).not_to be_nil
          expect(its_the_same_ca(account, CA_ACCOUNT_PERSISTED)).to be_truthy
        end
      end
    end

    describe '#GB' do
      context 'given a valid object' do
        account = GB_ACCOUNT_PERSISTED

        it 'creates the GB bank account entity' do
          expect(account).to be_kind_of MangoModel::GbBankAccount
          expect(account.id).not_to be_nil
          expect(its_the_same_gb(account, GB_ACCOUNT_PERSISTED)).to be_truthy
        end
      end
    end

    describe '#OTHER' do
      context 'given a valid object' do
        account = OTHER_ACCOUNT_PERSISTED

        it 'creates the OTHER bank account entity' do
          expect(account).to be_kind_of MangoModel::OtherBankAccount
          expect(account.id).not_to be_nil
          expect(its_the_same_other(account, OTHER_ACCOUNT_PERSISTED)).to be_truthy
        end
      end
    end
  end

  describe '.deactivate' do

    describe '#IBAN' do
      context 'given a valid object' do
        it 'deactivates the bank account entity' do
          # noinspection RubyResolve
          deactivate_and_check new_iban_account_persisted
        end
      end
    end

    describe '#US' do
      context 'given a valid object' do
        it 'deactivates the bank account entity' do
          # noinspection RubyResolve
          deactivate_and_check new_us_checking_account_persisted
        end
      end
    end

    describe '#CA' do
      context 'given a valid object' do
        it 'deactivates the bank account entity' do
          # noinspection RubyResolve
          deactivate_and_check new_ca_account_persisted
        end
      end
    end

    describe '#GB' do
      context 'given a valid object' do
        it 'deactivates the bank account entity' do
          # noinspection RubyResolve
          deactivate_and_check new_gb_account_persisted
        end
      end
    end

    describe '#OTHER' do
      context 'given a valid object' do
        it 'deactivates the bank account entity' do
          # noinspection RubyResolve
          deactivate_and_check new_other_account_persisted
        end
      end
    end
  end

  describe '.get' do

    describe '#IBAN' do
      describe "given an existing entity's ID" do
        it 'retrieves the corresponding entity' do
          get_and_check IBAN_ACCOUNT_PERSISTED
        end
      end
    end

    describe '#US' do
      describe "given an existing entity's ID" do
        it 'retrieves the corresponding entity' do
          get_and_check US_CHECKING_ACCOUNT_PERSISTED
        end
      end
    end

    describe '#CA' do
      describe "given an existing entity's ID" do
        it 'retrieves the corresponding entity' do
          get_and_check CA_ACCOUNT_PERSISTED
        end
      end
    end

    describe '#GB' do
      describe "given an existing entity's ID" do
        it 'retrieves the corresponding entity' do
          get_and_check GB_ACCOUNT_PERSISTED
        end
      end
    end

    describe '#OTHER' do
      describe "given an existing entity's ID" do
        it 'retrieves the corresponding entity' do
          get_and_check OTHER_ACCOUNT_PERSISTED
        end
      end
    end
  end

  describe '.all' do

    context 'not having specified filters' do
      results = MangoApi::BankAccounts.all(NATURAL_USER_PERSISTED.id)

      it 'retrieves list with default parameters' do
        expect(results).to be_kind_of Array
        results.each do |result|
          expect(result).to be_kind_of MangoModel::BankAccount
        end
      end
    end

    context 'having specified filters' do
      per_page = 3
      results = MangoApi::BankAccounts.all(NATURAL_USER_PERSISTED.id) do |filter|
        filter.page = 1
        filter.per_page = per_page
        filter.sort_field = MangoPay::SortField::CREATION_DATE
        filter.sort_direction = MangoPay::SortDirection::ASC
      end

      it 'retrieves list according to provided parameters' do
        expect(results).to be_kind_of Array
        expect(results.length).to eq per_page
        results.each.with_index do |result, index|
          expect(result).to be_kind_of MangoModel::BankAccount
          next if index == results.length - 1
          first_date = result.creation_date
          second_date = results[index + 1].creation_date
          expect(first_date <= second_date).to be_truthy
        end
      end
    end
  end
end

def deactivate_and_check(account)
  deactivated = MangoApi::BankAccounts.deactivate account.user_id, account.id

  expect(deactivated).to be_kind_of account.class
  expect(deactivated.id).to eq account.id
  expect(deactivated.active).to be_falsey
end

def get_and_check(account)
  retrieved = MangoApi::BankAccounts.get account.user_id, account.id

  expect(retrieved).to be_kind_of account.class
  expect(retrieved.id).to eq account.id
end