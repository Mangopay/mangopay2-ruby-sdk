require_relative '../uri_provider'

module MangoApi

  # Provides API method delegates concerning the +Repudiation+ entity
  module Repudiations
    class << self
      include UriProvider

      # Retrieves a repudiation entity.
      #
      # @param +id+ [String] ID of the repudiation to retrieve
      # @return [Repudiation] the requested Repudiation entity object
      def get(id)
        uri = provide_uri(:get_repudiation, id)
        response = HttpClient.get(uri)
        parse response
      end

      private

      # Parses a JSON-originating hash into the corresponding
      # Repudiation entity object.
      #
      # @param +response+ [Hash] JSON-originating data hash
      # @return [Repudiation] corresponding Repudiation entity object
      def parse(response)
        MangoModel::Repudiation.new.dejsonify response
      end
    end
  end
end