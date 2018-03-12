require_relative '../uri_provider'

module MangoApi

  # Provides API method delegates concerning the +Event+ entity
  module Events
    class << self
      include UriProvider

      # Retrieves list of Event entity pages.
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
      # * event_type
      #
      # @return [Array] requested Event entity objects
      def all
        uri = provide_uri(:get_events)
        filter_request = nil
        yield filter_request = FilterRequest.new if block_given?
        results = HttpClient.get(uri, filter_request)
        parse_results results
      end

      private

      # Parses an array of JSON-originating hashes into the corresponding
      # Event entity objects.
      #
      # @param +results+ [Array] JSON-originating data hashes
      # @return [Array] parsed Event entity objects
      def parse_results(results)
        results.collect do |entity|
          MangoModel::Event.new.dejsonify entity
        end
      end
    end
  end
end