require_relative '../uri_provider'

module MangoApi

  # Provides API method delegates concerning the +SettlementTransfer+ entity
  module SettlementTransfers
    class << self
      include UriProvider

      # Creates a new settlement transfer entity.
      #
      # +SettlementTransfer+ properties:
      # * Required
      #   * author_id
      #   * debited_funds
      #   * fees
      # * Optional
      #   * tag
      #
      # @param +repudiation_id+ [String] ID of the corresponding repudiation
      # @param +transfer+ [SettlementTransfer] model object of the settlement
      # transfer to be created
      # @return [SettlementTransfer] the newly-created SettlementTransfer
      # entity object
      def create(repudiation_id, transfer)
        uri = provide_uri(:create_settlement_transfer, repudiation_id)
        response = HttpClient.post(uri, transfer)
        parse response
      end

      # Retrieves a settlement transfer entity.
      #
      # @param +id+ [String] ID of the settlement transfer to retrieve
      # @return [SettlementTransfer] the requested SettlementTransfer
      # entity object
      def get(id)
        uri = provide_uri(:get_settlement_transfer, id)
        response = HttpClient.get(uri)
        parse response
      end

      private

      # Parses a JSON-originating hash into the corresponding
      # SettlementTransfer entity object.
      #
      # @param +response+ [Hash] JSON-originating data hash
      # @return [SettlementTransfer] corresponding SettlementTransfer
      # entity object
      def parse(response)
        MangoModel::SettlementTransfer.new.dejsonify response
      end
    end
  end
end