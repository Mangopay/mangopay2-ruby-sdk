require_relative '../uri_provider'

module MangoApi

  # Provides API method delegates concerning the +Mandate+ entity
  module Mandates
    class << self
      include UriProvider

      # Creates a new mandate entity.
      #
      # +Mandate+ properties:
      # * Required
      #   * bank_account_id
      #   * culture
      #   * return_url
      # * Optional
      #   * tag
      #
      # @param +mandate+ [Mandate] model object of mandate to be created
      # @param +id_key+ [String] idempotency key for future response replication
      # @return [Mandate] the newly-created Mandate entity object
      def create(mandate, id_key = nil)
        uri = provide_uri(:create_mandate)
        response = HttpClient.post(uri, mandate, id_key)
        parse response
      end

      # Retrieves a mandate entity.
      #
      # @param +id+ [String] ID of the mandate to retrieve
      # @return [Mandate] the requested Mandate entity object
      def get(id)
        uri = provide_uri(:get_mandate, id)
        response = HttpClient.get(uri)
        parse response
      end

      # Cancels a mandate.
      #
      # @param +id+ [String] ID of the mandate to cancel
      # @return [Mandate] the updated Mandate entity object
      def cancel(id)
        uri = provide_uri(:cancel_mandate, id)
        response = HttpClient.put(uri)
        parse response
      end

      # Retrieves mandate entity pages. Allows configuration
      # of paging and sorting parameters by yielding a filtering
      # object to a provided block. When no filters are specified,
      # will retrieve the first page of 10 newest results.
      #
      # Allowed +FilterRequest+ params:
      # * page
      # * per_page
      # * sort_field and sort_direction
      # * before_date
      # * after_date
      #
      # @return [Array] array of hashed mandate entities corresponding
      # to provided filters
      def all
        uri = provide_uri(:get_mandates)
        filter_request = nil
        yield filter_request = FilterRequest.new if block_given?
        results = HttpClient.get(uri, filter_request)
        parse_results results
      end

      # Retrieves pages of mandate entities belonging to a certain user.
      # Allows configuration of paging and sorting parameters by yielding
      # a filtering object to a provided block. When no filters are
      # specified, will retrieve the first page of 10 newest results
      #
      # Allowed +FilterRequest+ params:
      # * page
      # * per_page
      # * sort_field and sort_direction
      # * before_date
      # * after_date
      #
      # @param +id+ [String] ID of the user whose mandates to retrieve
      # @return [Array] array of hashed mandate entities corresponding
      # to provided filters
      def of_user(id)
        uri = provide_uri(:get_users_mandates, id)
        filter_request = nil
        yield filter_request = FilterRequest.new if block_given?
        results = HttpClient.get(uri, filter_request)
        parse_results results
      end

      # Retrieves pages of mandate entities belonging to a certain bank account.
      # Allows configuration of paging and sorting parameters by yielding
      # a filtering object to a provided block. When no filters are
      # specified, will retrieve the first page of 10 newest results
      #
      # Allowed +FilterRequest+ params:
      # * page
      # * per_page
      # * sort_field and sort_direction
      # * before_date
      # * after_date
      #
      # @param +user_id+ [String] ID of the user owning the bank account
      # @param +account_id+ [String] ID of the bank account whose mandates
      # to retrieve
      # @return [Array] array of hashed mandate entities corresponding
      # to provided filters
      def of_bank_account(user_id, account_id)
        uri = provide_uri(:get_accounts_mandates, user_id, account_id)
        filter_request = nil
        yield filter_request = FilterRequest.new if block_given?
        results = HttpClient.get(uri, filter_request)
        parse_results results
      end

      private

      # Parses an array of JSON-originating hashes into the corresponding
      # Mandate entity objects.
      #
      # @param +results+ [Array] JSON-originating data hashes
      # @return [Array] parsed Mandate entity objects
      def parse_results(results)
        results.collect do |entity|
          parse entity
        end
      end

      # Parses a JSON-originating hash into the corresponding
      # Mandate entity object.
      #
      # @param +response+ [Hash] JSON-originating data hash
      # @return [Mandate] corresponding Mandate entity object
      def parse(response)
        MangoModel::Mandate.new.dejsonify response
      end
    end
  end
end