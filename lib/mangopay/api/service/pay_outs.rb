require_relative '../uri_provider'

module MangoApi

  # Provides API method delegates concerning the +PayOut+ entity
  module PayOuts
    class << self
      include UriProvider

      # Creates a new pay-out entity.
      #
      # +PayOut+ properties:
      # * Required
      #   * author_id
      #   * debited_funds
      #   * fees
      #   * bank_account_id
      #   * debited_wallet_id
      # * Optional
      #   * tag
      #   * bank_wire_ref
      #
      # @param +pay_out+ [PayOut] model object of the pay-out to be created
      # @param +id_key+ [String] idempotency key for future response replication
      # @return [PayOut] the newly-created PayOut entity object
      def create(pay_out, id_key = nil)
        uri = provide_uri(:create_pay_out)
        response = HttpClient.post(uri, pay_out, id_key)
        parse response
      end

      # Retrieves a pay-out entity.
      #
      # @param +id+ [String] ID of the pay-out to retrieve
      # @return [PayOut] the requested PayOut entity object
      def get(id)
        uri = provide_uri(:get_pay_out, id)
        response = HttpClient.get(uri)
        parse response
      end

      private

      # Parses a JSON-originating hash into the corresponding
      # PayOut entity object.
      #
      # @param +response+ [Hash] JSON-originating data hash
      # @return [PayOut] corresponding PayOut entity object
      def parse(response)
        MangoModel::PayOut.new.dejsonify response
      end
    end
  end
end