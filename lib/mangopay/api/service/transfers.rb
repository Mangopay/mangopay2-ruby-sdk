require_relative '../uri_provider'

module MangoApi

  # Provides API method delegates concerning the +Transfer+ entity
  module Transfers
    class << self
      include UriProvider

      # Creates a new transfer entity.
      #
      # +Transfer+ properties:
      # * Required
      #   * author_id
      #   * debited_funds
      #   * fees
      #   * debited_wallet_id
      #   * credited_wallet_id
      # * Optional
      #   * tag
      #   * credited_user_id
      #
      # @param +transfer+ [Transfer] model object of transfer to be created
      # @param +id_key+ [String] idempotency key for future response replication
      # @return [Transfer] the newly-created Transfer entity object
      def create(transfer, id_key = nil)
        uri = provide_uri(:create_transfer)
        response = HttpClient.post(uri, transfer, id_key)
        parse response
      end

      # Retrieves a transfer entity.
      #
      # @param +id+ [String] ID of the transfer to be retrieved
      # @return [Transfer] the requested entity object
      def get(id)
        uri = provide_uri(:get_transfer, id)
        response = HttpClient.get(uri)
        parse response
      end

      private

      # Parses a JSON-originating hash into the corresponding
      # Transfer entity object.
      #
      # @param +response+ [Hash] JSON-originating data hash
      # @return [Transfer] corresponding Transfer entity object
      def parse(response)
        MangoModel::Transfer.new.dejsonify response
      end
    end
  end
end