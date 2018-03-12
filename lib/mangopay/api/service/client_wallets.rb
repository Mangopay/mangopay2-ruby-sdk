require_relative '../uri_provider'

module MangoApi

  # Provides API method delegates concerning the +ClientWallet+ entity
  module ClientWallets
    class << self
      include UriProvider

      # Retrieves a client wallet entity.
      # Client wallet entity of provided funds' type and currency will be
      # created if it does not yet exist.
      #
      # @param +funds_type+ [FundsType] funds' type of the wallet to retrieve
      # @param +currency+ [CurrencyIso] currency of the wallet to retrieve
      # @return [ClientWallet] the corresponding ClientWallet entity object
      def get(funds_type, currency)
        uri = provide_uri(:get_client_wallet, funds_type, currency)
        response = HttpClient.get(uri)
        parse response
      end

      # Retrieves client wallet entities. Allows configuration
      # of paging and sorting parameters by yielding a filtering
      # object to a provided block. When no filters are specified,
      # will retrieve the first page of 10 newest results.
      #
      # Allowed +FilterRequest+ params:
      # * page
      # * per_page
      # * sort_field and sort_direction
      #
      # @return [Array] array of hashed client wallet entities
      # corresponding to provided filters
      def all
        uri = provide_uri(:get_client_wallets)
        filter_request = nil
        yield filter_request = FilterRequest.new if block_given?
        results = HttpClient.get(uri, filter_request)
        parse_results results
      end

      # Retrieves client wallet entities of a certain funds type.
      # Allows configuration of paging and sorting parameters by
      # yielding a filtering object to a provided block. When no
      # filters are specified, will retrieve the first page of
      # 10 newest results.
      #
      # Allowed +FilterRequest+ params:
      # * page
      # * per_page
      # * sort_field and sort_direction
      #
      # @param +funds_type+ [FundsType] funds' type of the client
      # wallets to retrieve
      # @return [Array] array of hashed client wallet entities
      # corresponding to provided filters
      def of_funds_type(funds_type)
        uri = provide_uri(:get_client_wallets_funds_type, funds_type)
        filter_request = nil
        yield filter_request = FilterRequest.new if block_given?
        results = HttpClient.get(uri, filter_request)
        parse_results results
      end

      private

      # Parses an array of JSON-originating hashes into the corresponding
      # ClientWallet entity objects.
      #
      # @param +results+ [Array] JSON-originating data hashes
      # @return [Array] parsed ClientWallet entity objects
      def parse_results(results)
        results.collect do |entity|
          parse entity
        end
      end

      # Parses a JSON-originating hash into the corresponding
      # ClientWallet entity object.
      #
      # @param +response+ [Hash] JSON-originating data hash
      # @return [ClientWallet] corresponding ClientWallet entity object
      def parse(response)
        MangoModel::ClientWallet.new.dejsonify response
      end
    end
  end
end