require_relative '../uri_provider'
require_relative '../../util/file_encoder'
require_relative '../../model/request/upload_file_request'

module MangoApi

  # Provides API method delegates concerning the +Client+ entity
  module Clients
    class << self
      include UriProvider

      # Updates the current environment's client entity.
      #
      # +Client+ optional properties:
      # * primary_button_colour
      # * primary_theme_colour
      # * admin_emails
      # * tech_emails
      # * billing_emails
      # * fraud_emails
      # * headquarters_address
      # * tax_number
      # * platform_type
      # * platform_description
      # * platform_url
      #
      # @param +client+ [Client] client object with corresponding ID
      # and updated dat
      # @return [Client] updated Client entity object
      def update(client)
        uri = provide_uri(:update_client)
        response = HttpClient.put(uri, client)
        parse response
      end

      # Uploads the image file specified as the current
      # environment's client's logo.
      #
      # @param +path+ [String] path of the logo image
      def upload_logo(path)
        uri = provide_uri(:upload_client_logo)
        body = UploadFileRequest.new
        body.file = FileEncoder.encode_base64 path
        HttpClient.put(uri, body)
      end

      # Retrieves the current environment's client entity.
      #
      # @return [Client] current Client entity object
      def get
        uri = provide_uri(:get_client)
        response = HttpClient.get(uri)
        parse response
      end

      def create_bank_account(bank_account)
        uri = provide_uri(:client_create_bank_account)
        response = HttpClient.post(uri, bank_account)
        MangoModel::IbanBankAccount.new.dejsonify response
      end

      def create_payout(payout)
        uri = provide_uri(:client_create_payout)
        response = HttpClient.post(uri, payout)
        MangoModel::PayOut.new.dejsonify response
      end

      private

      # Parses a JSON-originating hash into the corresponding
      # Client entity object.
      #
      # @param +response+ [Hash] JSON-originating data hash
      # @return [Client] corresponding Client entity object
      def parse(response)
        MangoModel::Client.new.dejsonify response
      end
    end
  end
end