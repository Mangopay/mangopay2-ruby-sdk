require_relative '../uri_provider'
require_relative '../../model/request/filter_request'
require_relative '../../model/request/deactivation_request'

module MangoApi

  # Provides API method delegates concerning the +BankAccount+ entity
  module BankAccounts
    class << self
      include UriProvider

      # Creates a new bank account entity.
      #
      # +BankAccount+ properties:
      # * +IbanBankAccount
      #   * +tag+ - optional
      #   * +owner_address+ - required
      #   * +owner_name+ - required
      #   * +iban+ - required
      #   * +bic+ - optional
      # * +UsBankAccount+
      #   * +tag+ - optional
      #   * +owner_address+ - required
      #   * +owner_name+ - required
      #   * +account_number+ - required
      #   * +aba+ - required
      #   * +deposit_account_type+ - optional
      # * +CaBankAccount+
      #   * +tag+ - optional
      #   * +owner_address+ - required
      #   * +owner_name+ - required
      #   * +branch_code+ - required
      #   * +institution_number+ - required
      #   * +account_number+ - required
      #   * +bank_name+ - required
      # * +GbBankAccount+
      #   * +tag+ - optional
      #   * +owner_address+ - required
      #   * +owner_name+ - required
      #   * +sort_code+ - required
      #   * +account_number+ - required
      # * +OtherBankAccount+
      #   * +tag+ optional
      #   * +owner_address+ - required
      #   * +owner_name+ - required
      #   * +country+ - required
      #   * +bic+ - required
      #   * +account_number+ - required
      #
      # @param +account+ [BankAccount] model object of account to be created
      # @param +id_key+ [String] idempotency key for future response replication
      # @return [BankAccount] the newly-created BankAccount entity object
      def create(account, id_key = nil)
        uri = provide_uri(:create_account, account)
        response = HttpClient.post(uri, account, id_key)
        parse response
      end

      # Deactivates a bank account entity.
      #
      # @param +user_id+ [String] ID of the owner of the account
      # being deactivated
      # @param +account_id+ [String] ID of the bank account being deactivated
      # @return [BankAccount] deactivated BankAccount entity object
      def deactivate(user_id, account_id)
        uri = provide_uri(:deactivate_account, user_id, account_id)
        response = HttpClient.put(uri, DeactivationRequest.new)
        parse response
      end

      # Retrieves a bank account for a user.
      #
      # @param +user_id+ [String] ID of the bank account's owner
      # @param +account+id+ [String] ID of the bank account
      # @return [BankAccount] the corresponding BankAccount object
      def get(user_id, account_id)
        uri = provide_uri(:get_account, user_id, account_id)
        response = HttpClient.get(uri)
        parse response
      end

      # Retrieves pages of a user's bank accounts. Allows
      # configuration of paging and sorting parameters by
      # yielding a filtering object to a provided block.
      # When no filters are specified, will retrieve the
      # first page of 10 newest results.
      #
      # Allowed +FilterRequest+ params:
      # * page
      # * per_page
      # * sort_field and sort_direction
      #
      # @param +user_id+ [String] ID of the user whose bank accounts to get
      # @return [Array] parsed BankAccount entity objects
      def all(user_id)
        uri = provide_uri(:get_accounts, user_id)
        filter_request = nil
        yield filter_request = FilterRequest.new if block_given?
        results = HttpClient.get(uri, filter_request)
        parse_results results
      end

      private

      # Parses an array of JSON-originating hashes into the corresponding
      # BankAccount entity objects.
      #
      # @param +results+ [Array] JSON-originating data hashes
      # @return [Array] parsed BankAccount entity objects
      def parse_results(results)
        results.collect do |entity|
          parse entity
        end
      end

      # Parses a JSON-originating hash into the corresponding
      # BankAccount entity object.
      #
      # @param +response+ [Hash] JSON-originating data hash
      # @return [BankAccount] corresponding BankAccount entity object
      def parse(response)
        type = bank_account_type(response)
        type.new.dejsonify response
      end

      # Asserts the type of bank account represented by a hash.
      #
      # @param +hash+ [Hash] source hash
      # @return [Class] type of bank account represented by the hash
      def bank_account_type(hash)
        case hash['Type']
        when MangoModel::AccountType::IBAN.to_s
          MangoModel::IbanBankAccount
        when MangoModel::AccountType::US.to_s
          MangoModel::UsBankAccount
        when MangoModel::AccountType::CA.to_s
          MangoModel::CaBankAccount
        when MangoModel::AccountType::GB.to_s
          MangoModel::GbBankAccount
        else
          MangoModel::OtherBankAccount
        end
      end
    end
  end
end