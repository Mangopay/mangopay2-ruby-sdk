require 'base64'

module MangoPay

  # See https://docs.mangopay.com/api-references/disputes/disputes/
  class Dispute < Resource
    include HTTPCalls::Fetch
    include HTTPCalls::Update
    class << self

      def close(dispute_id, idempotency_key = nil)
        url = url(dispute_id) + "/close/"
        MangoPay.request(:put, url, {}, {}, idempotency_key)
      end

      # +contested_funds+: Money hash
      # see 'Contest' section @ https://docs.mangopay.com/api-references/disputes/disputes/
      def contest(dispute_id, contested_funds)
        url = url(dispute_id) + "/submit/"
        MangoPay.request(:put, url, {ContestedFunds: contested_funds})
      end

      def resubmit(dispute_id)
        url = url(dispute_id) + "/submit/"
        MangoPay.request(:put, url)
      end

      def transactions(dispute_id, filters = {})
        url = url(dispute_id) + "/transactions/"
        MangoPay.request(:get, url, {}, filters)
      end

      def fetch_for_user(user_id, filters = {})
        url = "#{MangoPay.api_path}/users/#{user_id}/disputes"
        MangoPay.request(:get, url, {}, filters)
      end

      def fetch_for_wallet(wallet_id, filters = {})
        url = "#{MangoPay.api_path}/wallets/#{wallet_id}/disputes"
        MangoPay.request(:get, url, {}, filters)
      end

      def fetch_pending_settlement(filters = {})
        url = "#{MangoPay.api_path}/disputes/pendingsettlement"
        MangoPay.request(:get, url, {}, filters)
      end

      #####################################################
      # repudiations / settlement transfers
      #####################################################

      # see https://docs.mangopay.com/api-references/disputes/repudiations/
      def fetch_repudiation(repudiation_id, idempotency_key = nil)
        url = "#{MangoPay.api_path}/repudiations/#{repudiation_id}"
        MangoPay.request(:get, url, {}, {}, idempotency_key)
      end

      # +params+: hash; see https://docs.mangopay.com/api-references/disputes/settlement-transfers/
      def create_settlement_transfer(repudiation_id, params, idempotency_key = nil)
        url = "#{MangoPay.api_path}/repudiations/#{repudiation_id}/settlementtransfer/"
        MangoPay.request(:post, url, params, {}, idempotency_key)
      end

      # see https://docs.mangopay.com/api-references/disputes/settlement-transfers/
      def fetch_settlement_transfer(transfer_id)
        url = "#{MangoPay.api_path}/settlements/#{transfer_id}"
        MangoPay.request(:get, url)
      end

      #####################################################
      # documents
      #####################################################

      # +params+: hash; see https://docs.mangopay.com/api-references/disputes/dispute-documents/
      def create_document(dispute_id, params, idempotency_key = nil)
        url = url(dispute_id) + "/documents/"
        MangoPay.request(:post, url, params, {}, idempotency_key)
      end

      def fetch_document(document_id)
        url = "#{MangoPay.api_path}/dispute-documents/#{document_id}"
        MangoPay.request(:get, url)
      end

      # +params+: hash; see 'Edit' section @ https://docs.mangopay.com/api-references/disputes/dispute-documents/
      def update_document(dispute_id, document_id, params)
        url = url(dispute_id) + "/documents/#{document_id}"
        MangoPay.request(:put, url, params)
      end

      # Fetches list of dispute documents:
      # - for the particular dispute if +dispute_id+ is provided (not nil)
      # - or for all disputes otherwise.
      #
      # Optional +filters+ is a hash accepting following keys:
      # - +page+, +per_page+, +sort+: pagination and sorting params (see MangoPay::HTTPCalls::Fetch::ClassMethods#fetch)
      # - filters such as +Type+ (e.g. 'REFUND_PROOF') and +Status+ (e.g. 'VALIDATED')
      # - +BeforeDate+ (timestamp): filters documents with CreationDate _before_ this date
      # - +AfterDate+ (timestamp): filters documents with CreationDate _after_ this date
      #
      # See https://docs.mangopay.com/api-references/disputes/dispute-documents/
      #
      def fetch_documents(dispute_id = nil, filters = {})
        url = (dispute_id) ? url(dispute_id) + "/documents/" : "#{MangoPay.api_path}/dispute-documents/"
        MangoPay.request(:get, url, {}, filters)
      end

      # Adds the file page (attachment) to the given document.
      #
      # See https://docs.mangopay.com/api-references/disputes/dispute-document-pages/ :
      # - Document have to be in 'CREATED' Status
      # - You can create as many pages as needed
      # - Change Status to 'VALIDATION_ASKED' to submit dispute documents
      #
      # The file_content_base64 param may be:
      # - Base64 encoded file content
      # - or nil: in this case pass the file path in the next param
      #
      def create_document_page(dispute_id, document_id, file_content_base64, file_path = nil, idempotency_key = nil)
        if file_content_base64.nil? && !file_path.nil?
          bts = File.open(file_path, 'rb') { |f| f.read }
          file_content_base64 = Base64.encode64(bts)
        end
        # normally it returns 204 HTTP code on success
        begin
          url = url(dispute_id) + "/documents/#{document_id}/pages"
          MangoPay.request(:post, url, {'File' => file_content_base64}, {}, idempotency_key)
        rescue ResponseError => ex
          raise ex unless ex.code == '204'
        end
      end

      # Creates temporary URLs where each page of
      # a dispute document can be viewed.
      #
      # @param +document_id+ ID of the document whose pages to consult
      # @return Array of consults for viewing the dispute document's pages
      def create_document_consult(document_id)
        MangoPay.request(:get, consult_url(document_id), {}, {})
      end

      def consult_url(document_id)
        "#{MangoPay.api_path}/dispute-documents/#{document_id}/consult"
      end
    end
  end
end
