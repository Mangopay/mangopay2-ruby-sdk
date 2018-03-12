require_relative '../../lib/mangopay/api/service/events'
require_relative '../../lib/mangopay/common/sort_field'
require_relative '../../lib/mangopay/common/sort_direction'

describe MangoApi::Events do

  describe '.all' do

    context 'from a correctly-configured environment' do
      context 'not having specified filters' do
        default_per_page = 10

        it 'retrieves list with default parameters' do
          results = MangoApi::Events.all

          expect(results).to be_kind_of Array
          expect(results.length).to eq default_per_page
          results.each do |result|
            expect(result).to be_kind_of MangoModel::Event
            expect(result.resource_id).not_to be_nil
          end
        end
      end

      context 'having specified filters' do
        per_page = 13

        it 'retrieves list with specified parameters' do
          results = MangoApi::Events.all do |filter|
            filter.page = 1
            filter.per_page = per_page
            filter.sort_field = MangoPay::SortField::DATE
            filter.sort_direction = MangoPay::SortDirection::DESC
          end

          expect(results).to be_kind_of Array
          expect(results.length).to eq per_page
          results.each.with_index do |result, index|
            expect(result).to be_kind_of MangoModel::Event
            expect(result.resource_id).not_to be_nil
            next if index == results.length - 1
            first_date = result.date
            second_date = results[index + 1].date
            expect(first_date >= second_date).to be_truthy
          end
        end
      end
    end
  end
end