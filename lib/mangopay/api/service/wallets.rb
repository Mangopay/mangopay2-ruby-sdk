require_relative '../uri_provider'
require_relative '../../model/request/filter_request'

module MangoApi

  # Provides API method delegates concerning the +Wallet+ entity.
  module Wallets
    class << self
      include UriProvider

      # Creates a new wallet entity.
      #
      # +Wallet+ properties:
      # * Required
      #   * owners
      #   * description
      #   * currency
      # * Optional
      #   * tag
      #
      # @param +wallet+ [Wallet] model object of wallet to be created
      # @param +id_key+ [String] idempotency key for future response replication
      # @return [Wallet] the newly-created Wallet entity object
      def create(wallet, id_key = nil)
        uri = provide_uri(:create_wallet)
        response = HttpClient.post(uri, wallet, id_key)
        parse response
      end

      # Updates the wallet entity identifiable by
      # the provided wallet object's ID.
      #
      # +Wallet+ optional properties:
      # * tag
      # * description
      #
      # @param +wallet+ [Wallet] wallet object with corresponding ID
      # and updated data
      # @return [Wallet] updated wallet entity
      def update(wallet)
        uri = provide_uri(:update_wallet, wallet)
        response = HttpClient.put(uri, wallet)
        parse response
      end

      # Retrieves a wallet entity.
      #
      # @param +id+ [String] ID of the wallet to be retrieved
      # @return [Wallet] the requested entity
      def get(id)
        uri = provide_uri(:get_wallet, id)
        response = HttpClient.get(uri)
        parse response
      end

      # Retrieves pages of wallet entities belonging to a certain user entity.
      # Allows configuration of paging and sorting parameters by
      # yielding a filtering object to a provided block. When no filters
      # are specified, will retrieve the first page of 10 newest results.
      #
      # Allowed +FilterRequest+ params:
      # * page
      # * per_page
      # * sort_field and sort_direction
      #
      # @param +id+ [String] ID of the user whose wallets to retrieve
      # @return [Array] the requested entities
      def of_user(id)
        uri = provide_uri(:get_users_wallets, id)
        filter_request = nil
        yield filter_request = FilterRequest.new if block_given?
        results = HttpClient.get(uri, filter_request)
        parse_results results
      end

      private

      # Parses an array of JSON-originating hashes into the corresponding
      # Wallet entity objects.
      #
      # @param +results+ [Array] JSON-originating data hashes
      # @return [Array] parsed Wallet entity objects
      def parse_results(results)
        results.collect do |entity|
          parse entity
        end
      end

      # Parses a JSON-originating hash into the corresponding
      # Wallet entity object.
      #
      # @param +response+ [Hash] JSON-originating data hash
      # @return [Wallet] corresponding Wallet entity object
      def parse(response)
        MangoModel::Wallet.new.dejsonify response
      end
    end
  end
end