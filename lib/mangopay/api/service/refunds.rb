require_relative '../uri_provider'

module MangoApi

  # Provides API method delegates concerning the +Refund+ entity
  module Refunds
    class << self
      include UriProvider

      # Creates a Pay-In Refund, which is a request to reimburse a user
      # on their payment card. The money which was paid will automatically
      # go back to the user's bank account.
      #
      # +Refund+ properties:
      # * Required
      #   * author_id
      # * Optional
      #   * tag
      #   * debited_funds
      #   * fees
      #
      # @param +id+ [String] ID of the pay-in being refunded
      # @param +refund+ [Refund] model object of the refund being created
      # @param +id_key+ [String] idempotency key for future response replication
      # @return [Refund] the newly-created Refund entity object
      def create_for_pay_in(id, refund, id_key = nil)
        uri = provide_uri(:create_pay_in_refund, id)
        response = HttpClient.post(uri, refund, id_key)
        parse response
      end

      # Creates a Transfer Refund.
      #
      # +Refund+ properties:
      # * Required
      #   * author_id
      # * Optional
      #   * tag
      #
      # @param +id+ [String] ID of the transfer being refunded
      # @param +refund+ [Refund] model object of the refund being created
      # @param +id_key+ [String] idempotency key for future response replication
      # @return [Refund] the newly-created Refund entity object
      def create_for_transfer(id, refund, id_key = nil)
        uri = provide_uri(:create_transfer_refund, id)
        response = HttpClient.post(uri, refund, id_key)
        parse response
      end

      private

      # Parses a JSON-originating hash into the corresponding
      # Refund entity object.
      #
      # @param +response+ [Hash] JSON-originating data hash
      # @return [Refund] corresponding Refund entity object
      def parse(response)
        MangoModel::Refund.new.dejsonify response
      end
    end
  end
end