require_relative '../context/kyc_document_context'
require_relative '../../lib/mangopay/api/service/kyc_documents'
require_relative '../../lib/mangopay/model/document_page_consult'
require_relative '../../lib/mangopay/model/entity/kyc_document'
require_relative '../../lib/mangopay/common/sort_field'
require_relative '../../lib/mangopay/common/sort_direction'

describe MangoApi::KycDocuments do
  include_context 'kyc_document_context'

  describe '.create' do

    context 'given a valid object' do
      kyc_doc = MangoModel::KycDocument.new
      kyc_doc.type = MangoModel::KycDocumentType::IDENTITY_PROOF

      it 'creates the kyc document entity' do
        created = MangoApi::KycDocuments.create kyc_doc, NATURAL_USER_PERSISTED.id

        expect(created).to be_kind_of MangoModel::KycDocument
        expect(created.id).not_to be_nil
        expect(created.status).to be MangoModel::DocumentStatus::CREATED
        expect(its_the_same_kyc_doc(kyc_doc, created)).to be_truthy
      end
    end
  end

  describe '.upload_page' do

    context "given a valid file's path" do
      path = File.join(File.dirname(__FILE__), '..', 'resources', 'test_pdf.pdf')

      it "uploads the file as one of the KYC document's pages" do
        response = MangoApi::KycDocuments.upload_page KYC_DOCUMENT_PERSISTED.id,
                                                      NATURAL_USER_PERSISTED.id,
                                                      path
        expect(response).to be_nil
      end
    end
  end

  describe '.submit' do

    context "given an existing entity's ID" do
      created = KYC_DOCUMENT_PERSISTED
      id = created.id
      # upload a page to allow submission
      path = File.join(File.dirname(__FILE__), '..', 'resources', 'test_pdf.pdf')
      MangoApi::KycDocuments.upload_page KYC_DOCUMENT_PERSISTED.id,
                                         NATURAL_USER_PERSISTED.id,
                                         path

      it 'submits the corresponding entity for approval' do
        submitted = MangoApi::KycDocuments.submit id, NATURAL_USER_PERSISTED.id

        expect(submitted).to be_kind_of MangoModel::KycDocument
        expect(submitted.id).to eq id
        expect(submitted.status).to be MangoModel::DocumentStatus::VALIDATION_ASKED
        expect(its_the_same_kyc_doc(created, submitted)).to be_truthy
      end
    end
  end

  describe '.of_user' do

    context "given an existing user entity's ID" do
      id = NATURAL_USER_PERSISTED.id
      # prepare some test data
      10.times do
        persist_kyc_doc KYC_DOCUMENT_DATA
      end

      context 'not having specified filters' do
        default_per_page = 10

        it 'retrieves list with default parameters' do
          results = MangoApi::KycDocuments.of_user id

          expect(results).to be_kind_of Array
          expect(results.length).to eq default_per_page
          results.each do |result|
            expect(result).to be_kind_of MangoModel::KycDocument
            expect(result.id).not_to be_nil
            expect(result.user_id).to eq id
          end
        end
      end

      context 'having specified filters' do
        per_page = 11

        it 'retrieves list with specified parameters' do
          results = MangoApi::KycDocuments.of_user id do |filter|
            filter.page = 1
            filter.per_page = per_page
            filter.sort_field = MangoPay::SortField::CREATION_DATE
            filter.sort_direction = MangoPay::SortDirection::ASC
          end

          expect(results).to be_kind_of Array
          expect(results.length).to eq per_page
          results.each.with_index do |result, index|
            expect(result).to be_kind_of MangoModel::KycDocument
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

  describe '.all' do

    context 'from a correctly-configured environment' do
      # prepare some test data
      10.times do
        persist_kyc_doc KYC_DOCUMENT_DATA
      end

      context 'not having specified filters' do
        default_per_page = 10

        it 'retrieves list with default parameters' do
          results = MangoApi::KycDocuments.all

          expect(results).to be_kind_of Array
          expect(results.length).to eq default_per_page
          results.each do |result|
            expect(result).to be_kind_of MangoModel::KycDocument
            expect(result.id).not_to be_nil
          end
        end
      end

      context 'having specified filters' do
        per_page = 11

        it 'retrieves list with specified parameters' do
          results = MangoApi::KycDocuments.all do |filter|
            filter.page = 1
            filter.per_page = per_page
            filter.sort_field = MangoPay::SortField::CREATION_DATE
            filter.sort_direction = MangoPay::SortDirection::ASC
          end

          expect(results).to be_kind_of Array
          expect(results.length).to eq per_page
          results.each.with_index do |result, index|
            expect(result).to be_kind_of MangoModel::KycDocument
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

  describe '.consult' do

    context "given an existing entity's ID" do
      id = KYC_DOCUMENT_PERSISTED.id

      it 'creates the document page consult entities' do
        results = MangoApi::KycDocuments.consult id

        expect(results).to be_kind_of Array
        results.each do |result|
          expect(result).to be_kind_of MangoModel::DocumentPageConsult
        end
      end
    end
  end
end