require_relative '../uri_provider'
require_relative '../../model/request/upload_file_request'
require_relative '../../util/file_encoder'
require_relative '../../model/request/submit_document_request'

module MangoApi

  # Provides API method delegates for the +DisputeDocument+ entity
  module DisputeDocuments
    class << self
      include UriProvider

      # Creates a new dispute document entity.
      #
      # +DisputeDocument+ properties:
      # * Required
      #   * type
      # * Optional
      #   * tag
      #
      # @param +document+ [DisputeDocument] model object of the dispute
      # document to be created
      # @param +dispute_id+ [String] ID of the corresponding dispute
      # @return [DisputeDocument] the newly-created DisputeDocument entity object
      def create(document, dispute_id)
        uri = provide_uri(:create_dispute_document, dispute_id)
        response = HttpClient.post(uri, document)
        parse response
      end

      # Uploads a dispute document page. Allowed extensions:
      # .pdf .jpeg .jpg .gif .png
      #
      # @param +id+ [String] ID of the dispute document entity
      # that the page is being uploaded for
      # @param +dispute_id+ [String] ID of the corresponding dispute entity
      # @param +path+ [String] path to the file to upload
      def upload_page(id, dispute_id, path)
        uri = provide_uri(:upload_dispute_document_page, dispute_id, id)
        body = UploadFileRequest.new
        body.file = FileEncoder.encode_base64 path
        HttpClient.post(uri, body)
      end

      # Submits a dispute document entity for approval
      #
      # @param +id+ [String] ID of the dispute document to submit
      # @param +dispute_id+ [String] ID of the corresponding dispute
      # @return [DisputeDocument] the submitted DisputeDocument entity object
      def submit(id, dispute_id)
        uri = provide_uri(:submit_dispute_document, dispute_id, id)
        request = SubmitDocumentRequest.new
        response = HttpClient.put(uri, request)
        parse response
      end

      # Retrieves a dispute document entity.
      #
      # @param +id+ [String] ID of the dispute document to retrieve
      # @return [DisputeDocument] the requested DisputeDocument entity object
      def get(id)
        uri = provide_uri(:get_dispute_document, id)
        response = HttpClient.get(uri)
        parse response
      end

      # Retrieves dispute documents belonging to a certain dispute.
      # Allows configuration of paging and sorting parameters by
      # yielding a filtering object to a provided block. When no filters are
      # specified, will retrieve the first page of 10 newest results.
      #
      # Allowed +FilterRequest+ params:
      # * page
      # * per_page
      # * sort_field and sort_direction
      # * before_date
      # * after_date
      # * status
      # * type
      #
      # @param +id+ [String] ID of the dispute whose documents to retrieve
      # @return [Array] corresponding DisputeDocument entity objects
      def of_dispute(id)
        uri = provide_uri(:get_disputes_documents, id)
        filter_request = nil
        yield filter_request = FilterRequest.new if block_given?
        results = HttpClient.get(uri, filter_request)
        parse_results results
      end

      # Retrieves dispute documents belonging to the current environment's
      # client. Allows configuration of paging and sorting parameters by
      # yielding a filtering object to a provided block. When no filters are
      # specified, will retrieve the first page of 10 newest results.
      #
      # Allowed +FilterRequest+ params:
      # * page
      # * per_page
      # * sort_field and sort_direction
      # * before_date
      # * after_date
      # * status
      # * type
      #
      # @return [Array] corresponding DisputeDocument entity objects
      def all
        uri = provide_uri(:get_dispute_documents)
        filter_request = nil
        yield filter_request = FilterRequest.new if block_given?
        results = HttpClient.get(uri, filter_request)
        parse_results results
      end

      # Creates temporary URLs where each page of a dispute document
      # can be viewed
      #
      # @param +id+ [String] ID of the document whose pages to consult
      # @return [Array] the corresponding DocumentPageConsult objects
      def consult(id)
        uri = provide_uri(:consult_dispute_document, id)
        results = HttpClient.post(uri, nil)
        parse_consults results
      end

      private

      # Parses an array of JSON-originating hashes into the corresponding
      # DisputeDocument entity objects.
      #
      # @param +results+ [Array] JSON-originating data hashes
      # @return [Array] parsed DisputeDocument entity objects
      def parse_results(results)
        results.collect do |entity|
          parse entity
        end
      end

      # Parses a JSON-originating hash into the corresponding
      # DisputeDocument entity object.
      #
      # @param +response+ [Hash] JSON-originating data hash
      # @return [DisputeDocument] corresponding DisputeDocument entity object
      def parse(response)
        MangoModel::DisputeDocument.new.dejsonify response
      end
      # Parses an array of JSON-originating hashes into the corresponding
      # DocumentPageConsult objects.
      #
      # @param +consults+ [Array] JSON-originating data hashes
      # @return [Array] corresponding DocumentPageConsult objects
      def parse_consults(consults)
        consults.collect do |consult|
          MangoModel::DocumentPageConsult.new.dejsonify consult
        end
      end
    end
  end
end