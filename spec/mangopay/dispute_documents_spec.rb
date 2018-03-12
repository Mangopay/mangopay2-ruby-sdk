require_relative '../../lib/mangopay/api/service/dispute_documents'
require_relative '../context/dispute_document_context'
require_relative '../../lib/mangopay/common/sort_field'
require_relative '../../lib/mangopay/common/sort_direction'

describe MangoApi::DisputeDocuments do
  include_context 'dispute_document_context'

  describe '.create' do

    context 'given a valid object' do
      id = DISPUTE_PERSISTED.id
      document = DISPUTE_DOCUMENT_DATA

      it 'creates the dispute document entity' do
        expect { MangoApi::DisputeDocuments.create(document, id) }.to(raise_error { |err|
          expect(err).to be_kind_of MangoPay::ResponseError
          expect(err.type).to eq 'dispute_can_not_currently_accept_documents'
        })
      end
    end
  end

  describe '.upload_page' do

    context "given a valid file's path" do
      path = File.join(File.dirname(__FILE__), '..', 'resources', 'test_pdf.pdf')

      it "uploads the file as one of the dispute document's pages" do
        expect do
          MangoApi::DisputeDocuments.upload_page(DISPUTE_DOCUMENT_PERSISTED.id,
                                                 DISPUTE_DOCUMENT_PERSISTED.dispute_id,
                                                 path)
        end.to(raise_error do |err|
          expect(err).to be_kind_of MangoPay::ResponseError
          expect(err.type).to eq 'dispute_can_not_currently_accept_documents'
        end)
      end
    end
  end

  describe '.submit' do

    context "given an existing entity's ID" do
      created = DISPUTE_DOCUMENT_PERSISTED
      id = created.id

      it 'submits the corresponding entity for approval' do
        expect { MangoApi::DisputeDocuments.submit(id, created.dispute_id) }.to(raise_error do |err|
          expect(err).to be_kind_of MangoPay::ResponseError
          expect(err.type).to eq 'cant_validate_empty_document'
        end)
      end
    end
  end

  describe '.get' do

    context "given an existing entity's ID" do
      document = DISPUTE_DOCUMENT_PERSISTED
      id = document.id

      it 'retrieves the corresponding entity' do
        retrieved = MangoApi::DisputeDocuments.get id

        expect(retrieved).to be_kind_of MangoModel::DisputeDocument
        expect(retrieved.id).to eq id
      end
    end
  end

  describe '.of_dispute' do

    context "given an existing dispute entity's ID" do
      id = DISPUTE_PERSISTED.id

      context 'not having specified filters' do
        it 'retrieves list with default parameters' do
          results = MangoApi::DisputeDocuments.of_dispute id

          expect(results).to be_kind_of Array
          results.each do |result|
            expect(result).to be_kind_of MangoModel::DisputeDocument
            expect(result.id).not_to be_nil
          end
        end
      end

      context 'having specified filters' do
        per_page = 5

        it 'retrieves a list with specified parameters' do
          results = MangoApi::DisputeDocuments.of_dispute id do |filter|
            filter.page = 1
            filter.per_page = per_page
            filter.sort_field = MangoPay::SortField::CREATION_DATE
            filter.sort_direction = MangoPay::SortDirection::DESC
          end

          expect(results).to be_kind_of Array
          expect(results.length).to eq per_page
          results.each.with_index do |result, index|
            expect(result).to be_kind_of MangoModel::DisputeDocument
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

  describe '.all' do

    context 'from a correctly-configured environment' do
      context 'not having specified filters' do
        default_per_page = 10

        it 'retrieves list with default parameters' do
          results = MangoApi::DisputeDocuments.all

          expect(results).to be_kind_of Array
          expect(results.length).to eq default_per_page
          results.each do |result|
            expect(result).to be_kind_of MangoModel::DisputeDocument
            expect(result.id).not_to be_nil
          end
        end
      end

      context 'having specified filters' do
        per_page = 11

        it 'retrieves list with specified parameters' do
          results = MangoApi::DisputeDocuments.all do |filter|
            filter.page = 1
            filter.per_page = per_page
            filter.sort_field = MangoPay::SortField::CREATION_DATE
            filter.sort_direction = MangoPay::SortDirection::DESC
          end

          expect(results).to be_kind_of Array
          expect(results.length).to eq per_page
          results.each.with_index do |result, index|
            expect(result).to be_kind_of MangoModel::DisputeDocument
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

  describe '.consult' do

    context "given an existing entity's ID" do
      id = DISPUTE_DOCUMENT_PERSISTED.id

      it 'creates the document page consult entities' do
        results = MangoApi::DisputeDocuments.consult id

        expect(results).to be_kind_of Array
        results.each do |result|
          expect(result).to be_kind_of MangoModel::DocumentPageConsult
        end
      end
    end
  end
end