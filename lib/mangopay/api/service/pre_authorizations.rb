require_relative '../uri_provider'
require_relative '../../model/request/cancel_request'

module MangoApi

  # Provides API method delegates concerning the +PreAuthorization+ entity
  module PreAuthorizations
    class << self
      include UriProvider

      # Creates a new Pre-Authorization entity.
      #
      # +PreAuthorization+ properties:
      # * Required
      #   * author_id
      #   * debited_funds
      #   * card_id
      #   * secure_mode_return_url
      # * Optional
      #   * tag
      #   * secure_mode
      #
      # @param +pre_auth+ [PreAuthorization] the pre-authorization
      # data model object
      # @param +id_key+ [String] idempotency key for future response replication
      # @return [PreAuthorization] the newly-created PreAuthorization
      # entity object
      def create(pre_auth, id_key = nil)
        uri = provide_uri(:create_pre_authorization)
        response = HttpClient.post(uri, pre_auth, id_key)
        parse response
      end

      # Retrieves a Pre-Authorization entity.
      #
      # @param +id+ [String] ID of the pre-authorization to retrieve
      # @return [PreAuthorization] the requested Pre-Authorization
      # entity object
      def get(id)
        uri = provide_uri(:get_pre_authorization, id)
        response = HttpClient.get(uri)
        parse response
      end

      # Retrieves pages of pre-authorization entities belonging to a certain
      # user. Allows configuration of paging and sorting parameters
      # by yielding a filtering object to a provided block. When no filters
      # are specified, will retrieve the first page of 10 newest results.
      #
      # Allowed +FilterRequest+ params:
      # * page
      # * per_page
      # * sort_field and sort_direction
      # * status
      # * result_code
      # * payment_status
      #
      # @param +id+ [String] ID of the dispute whose transactions to retrieve
      # @return [Array] the requested Transaction entity objects
      def of_user(id)
        uri = provide_uri(:get_users_pre_authorizations, id)
        filter_request = nil
        yield filter_request = FilterRequest.new if block_given?
        results = HttpClient.get(uri, filter_request)
        parse_results results
      end

      # Cancels a Pre-Authorization entity.
      #
      # @param +id+ [String] ID of the pre-authorization to cancel
      # @return [PreAuthorization] the requested Pre-Authorization
      # entity object
      def cancel(id)
        uri = provide_uri(:cancel_pre_authorization, id)
        cancel_request = CancelRequest.new
        response = HttpClient.put(uri, cancel_request)
        parse response
      end

      private

      # Parses a JSON-originating hash into the corresponding
      # PreAuthorization entity object.
      #
      # @param +response+ [Hash] JSON-originating data hash
      # @return [PreAuthorization] corresponding PreAuthorization entity object
      def parse(response)
        MangoModel::PreAuthorization.new.dejsonify response
      end

      # Parses an array of JSON-originating hashes into the corresponding
      # PreAuthorization entity objects.
      #
      # @param +results+ [Array] JSON-originating data hashes
      # @return [Array] parsed PreAuthorization entity objects
      def parse_results(results)
        results.collect do |entity|
          parse entity
        end
      end
    end
  end
end