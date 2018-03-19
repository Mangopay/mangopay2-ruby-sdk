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

      # Retrieves pages of refund entities belonging to a certain pay-out.
      # Allows configuration of paging and sorting parameters by yielding
      # a filtering object to a provided block. When no filters are specified,
      # will retrieve the first page of 10 newest results.
      #
      # Allowed +FilterRequest+ params:
      # * page
      # * per_page
      # * sort_field and sort_direction
      # * status
      # * result_code
      #
      # @param +id+ [String] ID of the pay-out whose refunds to retrieve
      # @return [Array] the requested Refund entity objects
      def of_pay_out(id)
        uri = provide_uri(:get_payouts_refunds, id)
        filter_request = nil
        yield filter_request = FilterRequest.new if block_given?
        results = HttpClient.get(uri, filter_request)
        parse_results results
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

      # Parses an Array of JSON-originating hashes into
      # corresponding Refund entity objects.
      #
      # @param +results+ [Array] JSON-originating data hashes
      # @return [Array] corresponding Refund entity objects
      def parse_results(results)
        results.collect do |entity|
          parse entity
        end
      end
    end
  end
end