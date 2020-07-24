require_relative '../uri_provider'

module MangoApi

  # Provides API method delegates concerning the +BankingAlias+ entity
  module BankingAliases
    class << self
      include UriProvider

      # Creates an IBAN banking alias
      #
      # +BankingAlias+ properties:
      # * Required:
      #   * credited_user_id
      #   * wallet_id
      #   * type
      #   * country
      #   * owner_name
      #   * active
      #  @param +banking_alias+ [BankingAlias] model object of banking alias to be created
      #  @param +wallet_id+ [String] the wallet_id
      #  @return [BakingAliasIBAN]
      def create_iban(banking_alias, wallet_id)
        uri = provide_uri(:banking_alias_create_iban, wallet_id)
        response = HttpClient.post(uri, banking_alias)
        parse response
      end

      # Retrieves a banking alias entity.
      #
      # @param +id+ [String] ID of the banking alias to be retrieved
      # @param +banking_alias+ [BankingAlias] Whether is active or not
      # @return [BankingAlias] the requested entity object
      def update(id, banking_alias)
        uri = provide_uri(:banking_alias_save, id)
        response = HttpClient.put(uri, banking_alias)
        parse response
      end

      # Retrieves a banking alias entity.
      #
      # @param +id+ [String] ID of the banking alias to be retrieved
      # @return [BankingAlias] the requested entity object
      def get(id)
        uri = provide_uri(:banking_alias_get, id)
        response = HttpClient.get(uri)
        parse response
      end

      # Retrieves all banking alias entities corresponding to a waller.
      #
      # @param +id+ [String] ID of the banking alias to be retrieved
      # @return [List<BankingAlias>] the requested entity object
      def get_all(id)
        uri = provide_uri(:banking_alias_all, id)
        response = HttpClient.get(uri)
        parse_results response
      end

      private

      # Parses an array of JSON-originating hashes into the corresponding
      # BankingAlias entity objects.
      #
      # @param +results+ [Array] JSON-originating data hashes
      # @return [Array] parsed Mandate entity objects
      def parse_results(results)
        results.collect do |entity|
          parse entity
        end
      end

      # Parses a JSON-originating hash into the corresponding
      # BankingAlias entity object.
      #
      # @param +response+ [Hash] JSON-originating data hash
      # @return [BankingAlias] corresponding BankingAlias entity object
      def parse(response)
        MangoModel::BankingAlias.new.dejsonify response
      end
    end
  end
end