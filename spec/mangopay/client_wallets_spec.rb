require_relative '../../lib/mangopay/api/service/client_wallets'
require_relative '../../lib/mangopay/model/entity/client_wallet'
require_relative '../../lib/mangopay/common/sort_field'
require_relative '../../lib/mangopay/common/sort_direction'

describe MangoApi::ClientWallets do

  describe '.get' do

    context 'from a correctly-configured environment' do
      it "retrieves the environment's client's ClientWallet entities" do
        funds_type = MangoModel::FundsType::CREDIT
        currency = MangoModel::CurrencyIso::EUR
        retrieved = MangoApi::ClientWallets.get(funds_type, currency)

        expect(retrieved).to be_kind_of MangoModel::ClientWallet
        expect(retrieved.funds_type).to be funds_type
        expect(retrieved.currency).to be currency
      end
    end
  end

  describe '.all' do
    default_per_page = 10

    context 'not having specified filters' do
      results = MangoApi::ClientWallets.all

      it 'retrieves list with default parameters' do
        expect(results).to be_kind_of Array
        expect(results.length).to eq default_per_page
        results.each do |result|
          expect(result).to be_kind_of MangoModel::ClientWallet
        end
      end
    end

    context 'having specified filters' do
      per_page = 3
      results = MangoApi::ClientWallets.all do |filter|
        filter.page = 1
        filter.per_page = per_page
        filter.sort_field = MangoPay::SortField::CREATION_DATE
        filter.sort_direction = MangoPay::SortDirection::ASC
      end

      it 'retrieves list according to provided parameters' do
        expect(results).to be_kind_of Array
        expect(results.length).to eq per_page
        results.each.with_index do |result, index|
          expect(result).to be_kind_of MangoModel::ClientWallet
          next if index == results.length - 1
          first_date = result.creation_date
          second_date = results[index + 1].creation_date
          expect(first_date <= second_date).to be_truthy
        end
      end
    end
  end

  describe '.of_funds_type' do
    default_per_page = 10

    describe '#FEES' do
      funds_type = MangoModel::FundsType::FEES
      MangoApi::ClientWallets.get(funds_type, MangoModel::CurrencyIso::FKP)
      MangoApi::ClientWallets.get(funds_type, MangoModel::CurrencyIso::LAK)
      MangoApi::ClientWallets.get(funds_type, MangoModel::CurrencyIso::MMK)
      MangoApi::ClientWallets.get(funds_type, MangoModel::CurrencyIso::NOK)
      MangoApi::ClientWallets.get(funds_type, MangoModel::CurrencyIso::XBA)

      context 'not having specified filters' do
        it 'retrieves list with default parameters' do
          results = MangoApi::ClientWallets.of_funds_type(funds_type)

          check_results(results, default_per_page, funds_type)
        end
      end

      context 'having specified filters' do
        per_page = 3
        results = MangoApi::ClientWallets.of_funds_type(funds_type) do |filter|
          filter.page = 1
          filter.per_page = per_page
          filter.sort_field = MangoPay::SortField::CREATION_DATE
          filter.sort_direction = MangoPay::SortDirection::ASC
        end

        it 'retrieves list according to provided parameters' do
          check_results(results, per_page, funds_type)
          results.each.with_index do |result, index|
            next if index == results.length - 1
            first_date = result.creation_date
            second_date = results[index + 1].creation_date
            expect(first_date <= second_date).to be_truthy
          end
        end
      end
    end

    describe '#CREDIT' do
      funds_type = MangoModel::FundsType::FEES
      MangoApi::ClientWallets.get(funds_type, MangoModel::CurrencyIso::FKP)
      MangoApi::ClientWallets.get(funds_type, MangoModel::CurrencyIso::LAK)
      MangoApi::ClientWallets.get(funds_type, MangoModel::CurrencyIso::MMK)
      MangoApi::ClientWallets.get(funds_type, MangoModel::CurrencyIso::NOK)
      MangoApi::ClientWallets.get(funds_type, MangoModel::CurrencyIso::XBA)

      context 'not having specified filters' do
        it 'retrieves list with default parameters' do
          results = MangoApi::ClientWallets.of_funds_type(funds_type)

          check_results(results, default_per_page, funds_type)
        end
      end

      context 'having specified filters' do
        per_page = 3
        results = MangoApi::ClientWallets.of_funds_type(funds_type) do |filter|
          filter.page = 1
          filter.per_page = per_page
          filter.sort_field = MangoPay::SortField::CREATION_DATE
          filter.sort_direction = MangoPay::SortDirection::ASC
        end

        it 'retrieves list according to provided parameters' do
          check_results(results, per_page, funds_type)
          results.each.with_index do |result, index|
            next if index == results.length - 1
            first_date = result.creation_date
            second_date = results[index + 1].creation_date
            expect(first_date <= second_date).to be_truthy
          end
        end
      end
    end
  end
end

# noinspection RubyResolve
def check_results(results, per_page, funds_type)
  expect(results).to be_kind_of Array
  expect(results.length).to eq per_page
  results.each do |result|
    expect(result).to be_kind_of MangoModel::ClientWallet
    expect(result.funds_type).to be funds_type
  end
end