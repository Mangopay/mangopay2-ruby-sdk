require_relative '../uri_provider'
require_relative '../../util/file_encoder'
require_relative '../../model/request/upload_file_request'
require_relative '../../model/request/submit_document_request'

module MangoApi

  # Provides API method delegates concerning the +KycDocument+ entity
  class KycDocuments
    class << self
      include UriProvider

      # Creates a new KYC document entity.
      #
      # +KycDocument+ properties:
      # * Required
      #   * type
      # * Optional
      #   * tag
      #
      # @param +kyc_document+ [KycDocument] model object of the KYC document
      # to be created
      # @param +user_id+ [String] ID of the user who the document is being
      # created for
      # @param +id_key+ [String] idempotency key for future response replication
      # @return [KycDocument] the newly-created KycDocument entity object
      def create(kyc_document, user_id, id_key = nil)
        uri = provide_uri(:create_kyc_document, user_id)
        response = HttpClient.post(uri, kyc_document, id_key)
        parse response
      end

      # Uploads a KYC document page. Allowed file extensions:
      # .pdf .jpeg .jpg .gif .png
      #
      # @param +id+ [String] ID of the KYC document entity that the page
      # is being uploaded for
      # @param +user_id+ [String] ID of the user who the document is being
      # updated for
      # @param +path+ [String] path of the KYC document page image
      def upload_page(id, user_id, path)
        uri = provide_uri(:upload_kyc_document_page, user_id, id)
        body = UploadFileRequest.new
        body.file = FileEncoder.encode_base64 path
        HttpClient.post(uri, body)
      end

      # Submits a KYC document entity for approval.
      #
      # @param +id+ [String] ID of the KYC document to submit
      # @param +user_id+ [String] ID of the user who the document is being
      # submitted for
      # @param +tag+ [String] custom data to add with the request
      # @return [KycDocument] the submitted KycDocument entity object
      def submit(id, user_id, tag = nil)
        uri = provide_uri(:submit_kyc_document, user_id, id)
        request = SubmitDocumentRequest.new(tag)
        response = HttpClient.put(uri, request)
        parse response
      end

      # Retrieves pages of KYC document entities belonging to current
      # environment's client. Allows configuration of paging and sorting
      # parameters by yielding a filtering object to a provided block. When
      # no filters are specified, will retrieve the first page of 10 newest
      # results.
      #
      # Allowed +FilterRequest+ params:
      # * page
      # * per_page
      # * sort_field and sort_direction
      # * before_date
      # * after_date
      # * status
      #
      # @return [Array] the requested entities
      def all
        uri = provide_uri(:get_kyc_documents)
        filter_request = nil
        yield filter_request = FilterRequest.new if block_given?
        results = HttpClient.get(uri, filter_request)
        parse_docs results
      end

      # Retrieves pages of KYC document entities belonging to a certain
      # user entity. Allows configuration of paging and sorting parameters by
      # yielding a filtering object to a provided block. When no filters
      # are specified, will retrieve the first page of 10 newest results.
      #
      # Allowed +FilterRequest+ params:
      # * page
      # * per_page
      # * sort_field and sort_direction
      # * before_date
      # * after_date
      # * status
      #
      # @param +id+ [String] ID of the user whose KYC documents to retrieve
      # @return [Array] the requested entities
      def of_user(id)
        uri = provide_uri(:get_users_kyc_documents, id)
        filter_request = nil
        yield filter_request = FilterRequest.new if block_given?
        results = HttpClient.get(uri, filter_request)
        parse_docs results
      end

      # Creates temporary URLs where each page of a KYC document
      # can be viewed.
      #
      # @param +id+ [String] ID of the KYC documents which to consult
      # @return [Array] +DocumentPageConsult+s for the document's pages
      def consult(id)
        uri = provide_uri(:consult_kyc_document, id)
        results = HttpClient.post(uri, nil)
        parse_consults results
      end

      private

      # Parses an array of JSON-originating hashes into the corresponding
      # KycDocument entity objects.
      #
      # @param +results+ [Array] JSON-originating data hashes
      # @return [Array] parsed KycDocument entity objects
      def parse_docs(results)
        results.collect do |entity|
          parse entity
        end
      end

      # Parses a JSON-originating hash into the corresponding
      # KycDocument entity object.
      #
      # @param +response+ [Hash] JSON-originating data hash
      # @return [KycDocument] corresponding KycDocument entity object
      def parse(response)
        MangoModel::KycDocument.new.dejsonify response
      end

      # Parses an array of JSON-originating hashes into the corresponding
      # DocumentPageConsult entity objects.
      #
      # @param +results+ [Array] JSON-originating data hashes
      # @return [Array] parsed DocumentPageConsult entity objects
      def parse_consults(results)
        results.collect do |entity|
          MangoModel::DocumentPageConsult.new.dejsonify entity
        end
      end
    end
  end
end