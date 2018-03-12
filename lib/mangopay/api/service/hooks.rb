require_relative '../uri_provider'
require_relative '../../model/request/filter_request'

module MangoApi

  # Provides API method delegates concerning the +Hook+ entity
  module Hooks
    class << self
      include UriProvider

      # Creates a new hook entity.
      #
      # +Hook+ properties:
      # * Required
      #   * event_type
      #   * url
      # * Optional
      #   * tag
      #
      # @param +hook+ [Hook] model object of the hook to be created
      # @param +id_key+ [String] idempotency key for future response replication
      # @return [Hook] the newly-created Hook entity object
      def create(hook, id_key = nil)
        uri = provide_uri(:create_hook)
        response = HttpClient.post(uri, hook, id_key)
        parse response
      end

      # Updates the hook entity identifiable by the provided
      # Hook object's ID.
      #
      # +Hook+ optional properties:
      # * tag
      # * status
      # * url
      #
      # @param +hook+ [Hook] hook object with corresponding ID
      # and updated data
      # @return [Hook] the updated Hook entity object
      def update(hook)
        uri = provide_uri(:update_hook, hook.id)
        response = HttpClient.put(uri, hook)
        parse response
      end

      # Retrieves a hook entity.
      #
      # @param +id+ [String] ID of the hook to retrieve
      # @return [Hook] the requested Hook entity object
      def get(id)
        uri = provide_uri(:get_hook, id)
        response = HttpClient.get(uri)
        parse response
      end

      # Retrieves all hooks.
      #
      # Allowed +FilterRequest+ params:
      # * page
      # * per_page
      # * sort_field and sort_direction
      #
      # @return [Array] Hook entity objects
      def all
        uri = provide_uri(:get_hooks)
        results = HttpClient.get(uri)
        parse_results results
      end

      private

      # Parses an array of JSON-originating hashes into the corresponding
      # Hook entity objects.
      #
      # @param +results+ [Array] JSON-originating data hashes
      # @return [Array] parsed Hook entity objects
      def parse_results(results)
        results.collect do |entity|
          parse entity
        end
      end

      # Parses a JSON-originating hash into the corresponding
      # Hook entity object.
      #
      # @param +response+ [Hash] JSON-originating data hash
      # @return [Hook] corresponding Hook entity object
      def parse(response)
        MangoModel::Hook.new.dejsonify response
      end
    end
  end
end