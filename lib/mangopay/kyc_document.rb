require 'base64'

module MangoPay

  # See http://docs.mangopay.com/api-references/kyc/documents/
  class KycDocument < Resource
    class << self
      def create(user_id, params, idempotency_key = nil)
        MangoPay.request(:post, url(user_id), params, {}, idempotency_key)
      end

      def update(user_id, document_id, params = {}, idempotency_key = nil)
        MangoPay.request(:put, url(user_id, document_id), params, {}, idempotency_key)
      end

      # Fetches the KYC document belonging to the given +user_id+, with the given +document_id+.
      def fetch(user_id, document_id, idempotency_key = nil)
        url = (user_id) ? url(user_id, document_id) : "#{MangoPay.api_path}/KYC/documents/#{CGI.escape(document_id.to_s)}"
        MangoPay.request(:get, url, {}, {}, idempotency_key)
      end

      # Fetches list of KYC documents:
      # - for the particular user if +user_id+ is provided (not nil)
      # - or for all users otherwise.
      #
      # Optional +filters+ is a hash accepting following keys:
      # - +page+, +per_page+, +sort+: pagination and sorting params (see MangoPay::HTTPCalls::Fetch::ClassMethods#fetch)
      # - filters such as +Type+ (e.g. 'IDENTITY_PROOF') and +Status+ (e.g. 'VALIDATED')
      # - +BeforeDate+ (timestamp): filters documents with CreationDate _before_ this date
      # - +AfterDate+ (timestamp): filters documents with CreationDate _after_ this date
      #
      def fetch_all(user_id = nil, filters = {})
        url = (user_id) ? url(user_id) : "#{MangoPay.api_path}/KYC/documents"
        MangoPay.request(:get, url, {}, filters)
      end

      # Adds the file page (attachment) to the given document.
      #
      # See http://docs.mangopay.com/api-references/kyc/pages/ :
      # - Document have to be in 'CREATED' Status
      # - You can create as many pages as needed
      # - Change Status to 'VALIDATION_ASKED' to submit KYC documents
      #
      # The file_content_base64 param may be:
      # - Base64 encoded file content
      # - or nil: in this case pass the file path in the next param
      #
      def create_page(user_id, document_id, file_content_base64, file_path = nil, idempotency_key = nil)
        if file_content_base64.nil? && !file_path.nil?
          bts = File.open(file_path, 'rb') { |f| f.read }
          file_content_base64 = Base64.encode64(bts)
        end
        # normally it returns 204 HTTP code on success
        begin
          MangoPay.request(:post, url(user_id, document_id) + '/pages', {'File' => file_content_base64}, {}, idempotency_key)
        rescue ResponseError => ex
          raise ex unless ex.code == '204'
        end
      end

      def url(user_id, document_id = nil)
        if document_id
          "#{MangoPay.api_path}/users/#{CGI.escape(user_id.to_s)}/KYC/documents/#{CGI.escape(document_id.to_s)}"
        else
          "#{MangoPay.api_path}/users/#{CGI.escape(user_id.to_s)}/KYC/documents"
        end
      end

      # Creates temporary URLs where each page of
      # a KYC document can be viewed.
      #
      # @param +document_id+ ID of the document whose pages to consult
      # @return Array of consults for viewing the KYC document's pages
      def create_documents_consult(document_id)
        MangoPay.request(:post, consult_url(document_id), {}, {})
      end

      def consult_url(document_id)
        "#{MangoPay.api_path}/KYC/documents/#{document_id}/consult"
      end
    end
  end
end
