require_relative '../../lib/mangopay/api/service/reports'
require_relative '../../spec/context/report_context'
require_relative '../../lib/mangopay/common/sort_field'
require_relative '../../lib/mangopay/common/sort_direction'

describe MangoApi::Reports do
  include_context 'report_context'

  describe '.create_for_transactions' do

    context 'given a valid object' do
      report = REPORT_DATA

      it 'creates the transaction report entity' do
        created = MangoApi::Reports.create_for_transactions report do |filter|
          filter.type = [MangoModel::TransactionType::PAYIN]
          filter.status = [MangoModel::TransactionStatus::SUCCEEDED]
          filter.nature = [MangoModel::TransactionNature::REGULAR]
          filter.min_debited_funds_amount = 430
          filter.min_debited_funds_currency = MangoModel::CurrencyIso::EUR
          filter.max_debited_funds_amount = 8790
          filter.max_debited_funds_currency = MangoModel::CurrencyIso::EUR
          filter.min_fees_amount = 120
          filter.min_fees_currency = MangoModel::CurrencyIso::EUR
          filter.max_fees_amount = 450
          filter.max_fees_currency = MangoModel::CurrencyIso::EUR
        end

        expect(created).to be_kind_of MangoModel::Report
        expect(created.id).not_to be_nil
        expect(created.report_type).to be MangoModel::ReportType::TRANSACTIONS
        expect(created.status).to be MangoModel::ReportStatus::PENDING
      end
    end
  end

  describe '.create_for_wallets' do

    context 'given a valid object' do
      report = REPORT_DATA

      it 'creates the transaction report entity' do
        created = MangoApi::Reports.create_for_wallets report do |filter|
          filter.before_date = 1_463_440_221
          filter.after_date = 1_449_817_821
          filter.currency = MangoModel::CurrencyIso::EUR
          filter.min_balance_amount = 123
          filter.min_balance_currency = MangoModel::CurrencyIso::EUR
          filter.max_balance_amount = 1230
          filter.max_balance_currency = MangoModel::CurrencyIso::EUR
        end

        expect(created).to be_kind_of MangoModel::Report
        expect(created.id).not_to be_nil
        expect(created.report_type).to be MangoModel::ReportType::WALLETS
        expect(created.status).to be MangoModel::ReportStatus::PENDING
      end
    end
  end

  describe '.get' do

    context "given an existing entity's ID" do
      created = REPORT_PERSISTED
      id = created.id

      it 'retrieves the corresponding entity' do
        retrieved = MangoApi::Reports.get id

        expect(retrieved).to be_kind_of MangoModel::Report
        expect(retrieved.id).to eq id
      end
    end
  end

  describe '.all' do

    context 'from a correctly-configured environment' do
      context 'not having specified filters' do
        default_per_page = 10

        it 'retrieves list with default parameters' do
          results = MangoApi::Reports.all

          expect(results).to be_kind_of Array
          expect(results.length).to eq default_per_page
          results.each do |result|
            expect(result).to be_kind_of MangoModel::Report
            expect(result.id).not_to be_nil
          end
        end
      end

      context 'having specified filters' do
        per_page = 11

        it 'retrieves list with specified parameters' do
          results = MangoApi::Reports.all do |filter|
            filter.page = 1
            filter.per_page = per_page
            filter.sort_field = MangoPay::SortField::CREATION_DATE
            filter.sort_direction = MangoPay::SortDirection::DESC
          end

          expect(results).to be_kind_of Array
          expect(results.length).to eq per_page
          results.each.with_index do |result, index|
            expect(result).to be_kind_of MangoModel::Report
            expect(result.id).not_to be_nil
            next if index == results.length - 1
            first_date = result.creation_date
            second_date = results[index + 1].creation_date
            expect(first_date >= second_date).to be_truthy
          end
        end
      end
    end
  end
end