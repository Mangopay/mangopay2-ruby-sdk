require_relative '../../lib/mangopay/api/service/mandates'
require_relative '../../spec/context/mandate_context'
require_relative '../../lib/mangopay/common/sort_field'
require_relative '../../lib/mangopay/common/sort_direction'

describe MangoApi::Mandates do
  include_context 'mandate_context'

  describe '.create' do

    context 'given a valid object' do
      mandate = MANDATE_DATA

      it 'creates the mandate entity' do
        created = MangoApi::Mandates.create mandate

        expect(created).to be_kind_of MangoModel::Mandate
        expect(created.id).not_to be_nil
        expect(created.document_url).not_to be_nil
        expect(created.execution_type).to be MangoModel::MandateExecutionType::WEB
        expect(created.mandate_type).to be MangoModel::MandateType::DIRECT_DEBIT
        expect(created.redirect_url).not_to be_nil
        expect(created.return_url).not_to be_nil
        expect(created.status).to be MangoModel::MandateStatus::CREATED
        expect(created.user_id).not_to be_nil
        expect(its_the_same_mandate(mandate, created)).to be_truthy
      end
    end
  end

  describe '.get' do

    context "given an existing entity's ID" do
      mandate = MANDATE_PERSISTED
      id = mandate.id

      it 'retrieves the corresponding entity' do
        retrieved = MangoApi::Mandates.get id

        expect(retrieved).to be_kind_of MangoModel::Mandate
        expect(retrieved.id).to eq id
        expect(its_the_same_mandate(mandate, retrieved)).to be_truthy
      end
    end
  end

  # describe '.cancel' do
  #
  #   context "given an existing entity's ID" do
  #     mandate = MangoModel::Mandate.new
  #     mandate.bank_account_id = GB_ACCOUNT_PERSISTED.id
  #     mandate.culture = MangoModel::MandateCultureCode::EN
  #     mandate.return_url = 'http://www.my-site.com/returnURL/'
  #     created = MangoApi::Mandates.create mandate
  #     id = created.id
  #
  #     it 'cancels the corresponding entity' do
  #
  #       # Attention
  #       #
  #       # To make this test pass, you must pause execution with a breakpoint on
  #       # the following line, and use your browser to open the page received
  #       # in the +created.redirect_url+ property and click the Confirm button
  #       # before continuing.
  #       canceled = MangoApi::Mandates.cancel id # Place breakpoint here
  #
  #       expect(canceled).to be_kind_of MangoModel::Mandate
  #       expect(canceled.id).to eq id
  #       expect(canceled.status).to be MangoModel::MandateStatus::FAILED
  #       expect(canceled.result_code).to eq '001806' # cancelled
  #     end
  #   end
  # end

  describe '.all' do

    context 'not having specified filters' do
      default_per_page = 10

      it 'retrieves a list with default parameters' do
        results = MangoApi::Mandates.all

        expect(results).to be_kind_of Array
        expect(results.length).to eq default_per_page
        results.each do |result|
          expect(result).to be_kind_of MangoModel::Mandate
          expect(result.id).not_to be_nil
        end
      end
    end

    context 'having specified filters' do
      per_page = 11

      it 'retrieves a list with specified parameters' do
        results = MangoApi::Mandates.all do |filter|
          filter.page = 1
          filter.per_page = per_page
          filter.sort_field = MangoPay::SortField::CREATION_DATE
          filter.sort_direction = MangoPay::SortDirection::ASC
        end

        expect(results).to be_kind_of Array
        expect(results.length).to be per_page
        results.each.with_index do |result, index|
          expect(result).to be_kind_of MangoModel::Mandate
          expect(result.id).not_to be_nil
          next if index == results.length - 1
          first_date = result.creation_date
          second_date = results[index + 1].creation_date
          expect(first_date < second_date).to be_truthy
        end
      end
    end
  end

  describe '.of_user' do
    # prepare test data
    10.times do
      persist_mandate build_mandate
    end

    describe "given an existing user entity's ID" do
      id = NATURAL_USER_PERSISTED.id

      context 'not having specified filters' do
        default_per_page = 10

        it 'retrieves a list with default parameters' do
          results = MangoApi::Mandates.of_user id

          expect(results).to be_kind_of Array
          expect(results.length).to eq default_per_page
          results.each do |result|
            expect(result).to be_kind_of MangoModel::Mandate
            expect(result.id).not_to be_nil
            expect(result.user_id).to eq id
          end
        end
      end

      context 'having specified filters' do
        per_page = 8

        it 'retrieves a list with specified parameters' do
          results = MangoApi::Mandates.of_user id do |filter|
            filter.page = 1
            filter.per_page = per_page
            filter.sort_field = MangoPay::SortField::CREATION_DATE
            filter.sort_direction = MangoPay::SortDirection::ASC
          end

          expect(results).to be_kind_of Array
          expect(results.length).to be per_page
          results.each.with_index do |result, index|
            expect(result).to be_kind_of MangoModel::Mandate
            expect(result.id).not_to be_nil
            expect(result.user_id).to eq id
            next if index == results.length - 1
            first_date = result.creation_date
            second_date = results[index + 1].creation_date
            expect(first_date <= second_date).to be_truthy
          end
        end
      end
    end
  end

  describe '.of_bank_account' do

    context "given an existing bank account entity's ID" do
      user_id = NATURAL_USER_PERSISTED.id
      account_id = IBAN_ACCOUNT_PERSISTED.id

      context 'not having specified filters' do
        default_per_page = 10

        it 'retrieves a list with default parameters' do
          results = MangoApi::Mandates.of_bank_account(user_id, account_id)

          expect(results).to be_kind_of Array
          expect(results.length).to eq default_per_page
          results.each.with_index do |result, index|
            expect(result).to be_kind_of MangoModel::Mandate
            expect(result.id).not_to be_nil
            next if index == results.length - 1
            first_date = result.creation_date
            second_date = results[index + 1].creation_date
            expect(first_date <= second_date).to be_truthy
          end
        end
      end

      context 'having specified filters' do
        per_page = 3

        it 'retrieves a list according to specified parameters' do
          results = MangoApi::Mandates.of_bank_account(user_id, account_id) do |filter|
            filter.page = 1
            filter.per_page = per_page
            filter.sort_field = MangoPay::SortField::CREATION_DATE
            filter.sort_direction = MangoPay::SortDirection::ASC
          end

          expect(results).to be_kind_of Array
          expect(results.length).to eq per_page
          results.each.with_index do |result, index|
            expect(result).to be_kind_of MangoModel::Mandate
            expect(result.id).not_to be_nil
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