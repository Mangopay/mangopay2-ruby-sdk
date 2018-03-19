require_relative '../uri_provider'

module MangoApi

  # Provides API method delegates concerning the +Transaction+ entity
  module Transactions
    class << self
      include UriProvider

      # Retrieves pages of transaction entities belonging to a certain user.
      # Allows configuration of paging and sorting parameters by
      # yielding a filtering object to a provided block. When no filters
      # are specified, will retrieve the first page of 10 newest results.
      #
      # Allowed +FilterRequest+ params:
      # * page
      # * per_page
      # * sort_field and sort_direction
      # * before_date
      # * after_date
      # * status
      # * nature
      # * type
      #
      # @param +id+ [String] ID of the user whose transactions to retrieve
      # @return [Array] the requested Transaction entity objects
      def of_user(id)
        uri = provide_uri(:get_users_transactions, id)
        filter_request = nil
        yield filter_request = FilterRequest.new if block_given?
        results = HttpClient.get(uri, filter_request)
        parse_results results
      end

      # Retrieves pages of transaction entities belonging to a certain wallet.
      # Allows configuration of paging and sorting parameters by
      # yielding a filtering object to a provided block. When no filters
      # are specified, will retrieve the first page of 10 newest results.
      #
      # Allowed +FilterRequest+ params:
      # * page
      # * per_page
      # * sort_field and sort_direction
      # * before_date
      # * after_date
      # * status
      # * nature
      # * type
      #
      # @param +id+ [String] ID of the user whose transactions to retrieve
      # @return [Array] the requested Transaction entity objects
      def of_wallet(id)
        uri = provide_uri(:get_wallets_transactions, id)
        filter_request = nil
        yield filter_request = FilterRequest.new if block_given?
        results = HttpClient.get(uri, filter_request)
        parse_results results
      end

      # Retrieves pages of transaction entities belonging to a certain dispute.
      # Allows configuration of paging and sorting parameters by
      # yielding a filtering object to a provided block. When no filters
      # are specified, will retrieve the first page of 10 newest results.
      #
      # Allowed +FilterRequest+ params:
      # * page
      # * per_page
      # * sort_field and sort_direction
      # * before_date
      # * after_date
      # * status
      # * nature
      # * type
      #
      # @param +id+ [String] ID of the dispute whose transactions to retrieve
      # @return [Array] the requested Transaction entity objects
      def of_dispute(id)
        uri = provide_uri(:get_disputes_transactions, id)
        filter_request = nil
        yield filter_request = FilterRequest.new if block_given?
        results = HttpClient.get(uri, filter_request)
        parse_results results
      end

      # Retrieves pages of transaction entities belonging to
      # the current environment's client. Allows configuration of
      # paging and sorting parameters by yielding a filtering object
      # to a provided block. When no filters are specified, will
      # retrieve the first page of 10 newest results.
      #
      # Allowed +FilterRequest+ params:
      # * page
      # * per_page
      # * sort_field and sort_direction
      # * before_date
      # * after_date
      # * status
      # * nature
      # * type
      #
      # @return [Array] the requested Transaction entity objects
      def of_client
        uri = provide_uri(:get_clients_transactions)
        filter_request = nil
        yield filter_request = FilterRequest.new if block_given?
        results = HttpClient.get(uri, filter_request)
        parse_results results
      end

      # Retrieves pages of transaction entities belonging to
      # the current environment's client wallet specified by
      # +funds_type+ and +currency+. Allows configuration of
      # paging and sorting parameters by yielding a filtering object
      # to a provided block. When no filters are specified, will
      # retrieve the first page of 10 newest results.
      #
      # Allowed +FilterRequest+ params:
      # * page
      # * per_page
      # * sort_field and sort_direction
      # * before_date
      # * after_date
      # * status
      # * nature
      # * type
      #
      # @param +funds_type+ [FundsType] the funds' type of the wallet to
      # retrieve Transactions for
      # @return [Array] the requested Transaction entity objects
      def of_client_wallet(funds_type, currency)
        uri = provide_uri(:get_client_wallets_transactions,
                          funds_type,
                          currency)
        filter_request = nil
        yield filter_request = FilterRequest.new if block_given?
        results = HttpClient.get(uri, filter_request)
        parse_results results
      end

      # Retrieves pages of transaction entities belonging to a certain
      # pre-authorization. Allows configuration of paging and sorting parameters
      # by yielding a filtering object to a provided block. When no filters
      # are specified, will retrieve the first page of 10 newest results.
      #
      # Allowed +FilterRequest+ params:
      # * page
      # * per_page
      # * sort_field and sort_direction
      #
      # @param +id+ [String] ID of the dispute whose transactions to retrieve
      # @return [Array] the requested Transaction entity objects
      def of_pre_authorization(id)
        uri = provide_uri(:get_pre_authorizations_transactions, id)
        filter_request = nil
        yield filter_request = FilterRequest.new if block_given?
        results = HttpClient.get(uri, filter_request)
        parse_results results
      end

      private

      # Parses an array of JSON-originating hashes into the corresponding
      # Transaction entity objects.
      #
      # @param +results+ [Array] JSON-originating data hashes
      # @return [Array] parsed Transaction entity objects
      def parse_results(results)
        results.collect do |entity|
          parse entity
        end
      end

      # Parses a JSON-originating hash into the corresponding
      # Transaction entity object.
      #
      # @param +response+ [Hash] JSON-originating data hash
      # @return [Transaction] corresponding Transaction entity object
      def parse(response)
        MangoModel::Transaction.new.dejsonify response
      end
    end
  end
end