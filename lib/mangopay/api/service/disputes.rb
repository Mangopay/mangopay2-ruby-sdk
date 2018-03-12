require_relative '../uri_provider'
require_relative '../../model/request/filter_request'

module MangoApi

  # Provides API method delegates concerning the +Dispute+ entity
  module Disputes
    class << self
      include UriProvider

      # Updates the dispute entity identifiable by the provided
      # dispute object's ID.
      #
      # +Dispute+ optional properties:
      # * tag
      #
      # @param +dispute+ [Dispute] dispute object with corresponding ID
      # and updated data
      # @return [Dispute] the updated Dispute entity object
      def update(dispute)
        uri = provide_uri(:update_dispute, dispute.id)
        response = HttpClient.put(uri, dispute)
        parse response
      end

      # Closes a dispute, an optional action which effectively
      # confirms that the dispute will not be contested.
      #
      # @param +id+ [String] ID of the dispute to close
      # @return [Dispute] the closed Dispute entity object
      def close(id)
        uri = provide_uri(:close_dispute, id)
        response = HttpClient.put(uri, MangoModel::Dispute.new)
        parse response
      end

      # Contests a dispute entity.
      #
      # @param +dispute+ [Dispute] the dispute object
      # @return [Dispute] the contested Dispute entity object
      def submit(dispute)
        uri = provide_uri(:submit_dispute, dispute.id)
        response = HttpClient.put(uri, dispute)
        parse response
      end

      # Re-submits a dispute entity if it is reopened requiring
      # more documents.
      #
      # @param +id+ [String] ID of the dispute to re-submit
      # @return [Dispute] the re-submitted Dispute entity object
      def resubmit(id)
        uri = provide_uri(:resubmit_dispute, id)
        response = HttpClient.put(uri, MangoModel::Dispute.new)
        parse response
      end

      # Retrieves a dispute entity.
      #
      # @param +id+ [String] ID of the dispute to retrieve
      # @return [Dispute] the requested Dispute entity object
      def get(id)
        uri = provide_uri(:get_dispute, id)
        response = HttpClient.get(uri)
        parse response
      end

      # Retrieves dispute entities belonging to a certain user.
      # Allows configuration of paging and sorting parameters by
      # yielding a filtering object to a provided block. When no
      # filters are specified, will retrieve the first page of
      # 10 newest results.
      #
      # Allowed +FilterRequest+ params:
      # * page
      # * per_page
      # * sort_field and sort_direction
      # * before_date
      # * after_date
      # * dispute_type
      # * status
      #
      # @param +id+ [String] ID of the user whose disputes to retrieve
      # @return [Array] corresponding Dispute entity object
      def of_user(id)
        uri = provide_uri(:get_users_disputes, id)
        filter_request = nil
        yield filter_request = FilterRequest.new if block_given?
        results = HttpClient.get(uri, filter_request)
        parse_results results
      end

      # Retrieves dispute entities belonging to a certain wallet.
      # Allows configuration of paging and sorting parameters by
      # yielding a filtering object to a provided block. When no
      # filters are specified, will retrieve the first page of
      # 10 newest results.
      #
      # Allowed +FilterRequest+ params:
      # * page
      # * per_page
      # * sort_field and sort_direction
      # * before_date
      # * after_date
      # * dispute_type
      # * status
      #
      # @param +id+ [String] ID of the wallet whose disputes to retrieve
      # @return [Array] corresponding Dispute entity object
      def of_wallet(id)
        uri = provide_uri(:get_wallets_disputes, id)
        filter_request = nil
        yield filter_request = FilterRequest.new if block_given?
        results = HttpClient.get(uri, filter_request)
        parse_results results
      end

      # Retrieves dispute entities that allow a settlement transfer.
      # In the event of having credit following a Dispute (because
      # it was lost, or the full amount wasn't contested), a settlement
      # transfer can optionally be done to transfer funds from the original
      # wallet to the credit wallet. A dispute allows a settlement transfer
      # when there is remaining credit and when funds are still available
      # in the original wallet.
      #
      # Allowed +FilterRequest+ params:
      # * page
      # * per_page
      # * sort_field and sort_direction
      #
      # @return [Array] corresponding Dispute entity objects
      def pending_settlement
        uri = provide_uri(:get_disputes_pending_settlement)
        filter_request = nil
        yield filter_request = FilterRequest.new if block_given?
        results = HttpClient.get(uri, filter_request)
        parse_results results
      end

      # Retrieves dispute entities belonging to the current client.
      # Allows configuration of paging and sorting parameters by
      # yielding a filtering object to a provided block. When no
      # filters are specified, will retrieve the first page of
      # 10 newest results.
      #
      # Allowed +FilterRequest+ params:
      # * page
      # * per_page
      # * sort_field and sort_direction
      # * before_date
      # * after_date
      # * dispute_type
      # * status
      #
      # @return [Array] corresponding Dispute entity objects
      def all
        uri = provide_uri(:get_disputes)
        filter_request = nil
        yield filter_request = FilterRequest.new if block_given?
        results = HttpClient.get(uri, filter_request)
        parse_results results
      end

      private

      # Parses an array of JSON-originating hashes into the corresponding
      # Dispute entity objects.
      #
      # @param +results+ [Array] JSON-originating data hashes
      # @return [Array] parsed Dispute entity objects
      def parse_results(results)
        results.collect do |entity|
          parse entity
        end
      end

      # Parses a JSON-originating hash into the corresponding
      # Dispute entity object.
      #
      # @param +response+ [Hash] JSON-originating data hash
      # @return [Dispute] corresponding Dispute entity object
      def parse(response)
        MangoModel::Dispute.new.dejsonify response
      end
    end
  end
end