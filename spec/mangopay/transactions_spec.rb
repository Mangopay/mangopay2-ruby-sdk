require_relative '../../lib/mangopay/api/service/transactions'
require_relative '../../lib/mangopay/api/service/clients'
require_relative '../context/dispute_context'
require_relative '../context/pre_authorization_context'
require_relative '../../lib/mangopay/common/sort_field'
require_relative '../../lib/mangopay/common/sort_direction'

describe MangoApi::Transactions do
  include_context 'dispute_context'
  include_context 'pre_authorization_context'

  describe '.of_user' do

    context "given an existing user entity's id" do
      id = NATURAL_USER_PERSISTED.id

      context 'not having specified filters' do
        results = MangoApi::Transactions.of_user id

        it 'retrieves list with default parameters' do
          expect(results).to be_kind_of Array
          results.each do |result|
            expect(result).to be_kind_of MangoModel::Transaction
            expect(result.id).not_to be_nil
            expect(result.author_id).to eq id
          end
        end
      end

      context 'having specified filters' do
        results = MangoApi::Transactions.of_user id do |filter|
          filter.page = 1
          filter.per_page = 3
          filter.sort_field = MangoPay::SortField::CREATION_DATE
          filter.sort_direction = MangoPay::SortDirection::ASC
        end

        it 'retrieves list with specified parameters' do
          expect(results).to be_kind_of Array
          results.each do |result|
            expect(result).to be_kind_of MangoModel::Transaction
            expect(result.id).not_to be_nil
            expect(result.author_id).to eq id
          end
        end
      end
    end
  end

  describe '.of_wallet' do

    describe "given an existing wallet entity's id" do
      id = WALLET_PERSISTED.id

      context 'not having specified filters' do
        results = MangoApi::Transactions.of_wallet id

        it 'retrieves list with default parameters' do
          expect(results).to be_kind_of Array
          results.each do |result|
            expect(result).to be_kind_of MangoModel::Transaction
            expect(result.id).not_to be_nil
            expect(result.credited_wallet_id == id \
                     || result.debited_wallet_id == id).to be_truthy
          end
        end
      end

      context 'having specified filters' do
        results = MangoApi::Transactions.of_wallet id do |filter|
          filter.page = 1
          filter.per_page = 3
          filter.sort_field = MangoPay::SortField::CREATION_DATE
          filter.sort_direction = MangoPay::SortDirection::ASC
        end

        it 'retrieves list with specified parameters' do
          expect(results).to be_kind_of Array
          results.each do |result|
            expect(result).to be_kind_of MangoModel::Transaction
            expect(result.id).not_to be_nil
            expect(result.credited_wallet_id == id \
                     || result.debited_wallet_id == id).to be_truthy
          end
        end
      end
    end
  end

  describe '.of_dispute' do

    describe "given an existing dispute entity's id" do
      id = DISPUTE_PERSISTED.id

      context 'not having specified filters' do
        results = MangoApi::Transactions.of_dispute id

        it 'retrieves list with default parameters' do
          expect(results).to be_kind_of Array
          results.each do |result|
            expect(result).to be_kind_of MangoModel::Transaction
            expect(result.id).not_to be_nil
          end
        end
      end

      context 'having specified filters' do
        results = MangoApi::Transactions.of_dispute  id do |filter|
          filter.page = 1
          filter.per_page = 3
          filter.sort_field = MangoPay::SortField::CREATION_DATE
          filter.sort_direction = MangoPay::SortDirection::ASC
        end

        it 'retrieves list with specified parameters' do
          expect(results).to be_kind_of Array
          results.each do |result|
            expect(result).to be_kind_of MangoModel::Transaction
            expect(result.id).not_to be_nil
          end
        end
      end
    end
  end

  describe '.of_client' do

    describe 'from a correctly-configured environment' do
      context 'not having specified filters' do
        results = MangoApi::Transactions.of_client

        it 'retrieves list with default parameters' do
          expect(results).to be_kind_of Array
          results.each do |result|
            expect(result).to be_kind_of MangoModel::Transaction
            expect(result.id).not_to be_nil
          end
        end
      end

      context 'having specified filters' do
        results = MangoApi::Transactions.of_client do |filter|
          filter.page = 1
          filter.per_page = 3
          filter.sort_field = MangoPay::SortField::CREATION_DATE
          filter.sort_direction = MangoPay::SortDirection::ASC
        end

        it 'retrieves list with specified parameters' do
          expect(results).to be_kind_of Array
          results.each do |result|
            expect(result).to be_kind_of MangoModel::Transaction
            expect(result.id).not_to be_nil
          end
        end
      end
    end
  end

  describe '.of_client_wallet' do

    describe 'from a correctly-configured environment' do
      context 'not having specified filters' do
        results = MangoApi::Transactions
                  .of_client_wallet MangoModel::FundsType::FEES,
                                    MangoModel::CurrencyIso::EUR

        it 'retrieves list with default parameters' do
          expect(results).to be_kind_of Array
          results.each do |result|
            expect(result).to be_kind_of MangoModel::Transaction
            expect(result.id).not_to be_nil
          end
        end
      end

      context 'having specified filters' do
        results = MangoApi::Transactions
                  .of_client_wallet(MangoModel::FundsType::CREDIT,
                                    MangoModel::CurrencyIso::EUR) do |filter|
          filter.page = 1
          filter.per_page = 3
          filter.sort_field = MangoPay::SortField::CREATION_DATE
          filter.sort_direction = MangoPay::SortDirection::ASC
        end

        it 'retrieves list with specified parameters' do
          expect(results).to be_kind_of Array
          results.each do |result|
            expect(result).to be_kind_of MangoModel::Transaction
            expect(result.id).not_to be_nil
          end
        end
      end
    end
  end

  describe '.of_pre_authorization' do

    describe "given a valid pre-authorization entity's ID" do
      id = PRE_AUTHORIZATION_PERSISTED.id

      context 'not having specified filters' do
        results = MangoApi::Transactions.of_pre_authorization id

        it 'retrieves list with default parameters' do
          expect(results).to be_kind_of Array
          results.each do |result|
            expect(result).to be_kind_of MangoModel::Transaction
            expect(result.id).not_to be_nil
          end
        end
      end

      context 'having specified filters' do
        results = MangoApi::Transactions.of_pre_authorization id do |filter|
          filter.page = 1
          filter.per_page = 3
          filter.sort_field = MangoPay::SortField::CREATION_DATE
          filter.sort_direction = MangoPay::SortDirection::ASC
        end

        it 'retrieves list with specified parameters' do
          expect(results).to be_kind_of Array
          results.each do |result|
            expect(result).to be_kind_of MangoModel::Transaction
            expect(result.id).not_to be_nil
          end
        end
      end
    end
  end

  describe '.of_card' do

    describe "given a valid card entity's ID" do
      id = CARD.id

      context 'not having specified filters' do
        results = MangoApi::Transactions.of_card id

        it 'retrieves list with default parameters' do
          expect(results).to be_kind_of Array
          results.each do |result|
            expect(result).to be_kind_of MangoModel::Transaction
            expect(result.id).not_to be_nil
          end
        end
      end

      context 'having specified filters' do
        results = MangoApi::Transactions.of_card id do |filter|
          filter.page = 1
          filter.per_page = 3
          filter.sort_field = MangoPay::SortField::CREATION_DATE
          filter.sort_direction = MangoPay::SortDirection::ASC
        end

        it 'retrieves list with specified parameters' do
          expect(results).to be_kind_of Array
          results.each do |result|
            expect(result).to be_kind_of MangoModel::Transaction
            expect(result.id).not_to be_nil
          end
        end
      end
    end
  end
end