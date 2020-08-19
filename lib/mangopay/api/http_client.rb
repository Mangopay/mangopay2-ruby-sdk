require 'net/http'
require 'json'
require_relative '../../mangopay'
require_relative '../common/log_provider'

module MangoApi

  # Handles HTTP communication.
  module HttpClient
    LOG = MangoPay::LogProvider.provide(self)

    class << self

      # Launches a self-configuring POST request,
      # with headers required by the API.
      #
      # @param +uri+ [String] request URI
      # @param +entity+ [Object] object to be JSON-serialized and sent as body
      #        Must include Jsonifier.
      # @param +id_key+ [String] idempotency key for future response replication
      # @return [Hash] hashed request response JSON body
      def post(uri, entity, id_key = nil)
        request proc { |ury, &block| post_raw(ury, &block) },
                uri,
                entity,
                nil,
                id_key
      end

      # Launches a fully customizable POST request.
      # Expects to be given a block to which it yields the
      # request object before execution to be configured.
      #
      # @param +uri+ [String] request URI
      # @return [Hash] hashed request response JSON body
      def post_raw(uri, &block)
        request_raw Net::HTTP::Post,
                    uri,
                    &block
      end

      # Launches a self-configuring PUT request,
      # with headers required by the API.
      #
      # @param +uri+ [URI] request URI
      # @param +entity+ [Object] object to be JSON-serialized and sent as body
      #        Must include Jsonifier.
      # @return [Hash] hashed request response JSON body
      def put(uri, entity = nil)
        request proc { |ury, &block| put_raw(ury, &block) },
                uri,
                entity
      end

      # Launches a fully customizable PUT request.
      # Expects to be given a block to which it yields the
      # request object before execution to be configured.
      #
      # @param +uri+ [String] request URI
      # @return [Hash] hashed request response JSON body
      def put_raw(uri, &block)
        request_raw Net::HTTP::Put,
                    uri,
                    &block
      end

      # Launches a self-configuring GET request,
      # with headers required by the API.
      # Applies filters if provided.
      #
      # @param +uri+ [URI] request URI
      # @param +filters+ [FilterRequest] response entity filtering object
      # @return [Hash] hashed request response JSON body
      def get(uri, filter_request = nil)
        request proc { |ury, &block| get_raw(ury, &block) },
                uri,
                nil,
                filter_request
      end

      # Launches a fully customizable GET request.
      # Expects to be given a block to which it yields the
      # request object before execution to be configured.
      #
      # @param +uri+ [URI] request URI
      # @return [Hash] hashed request response JSON body
      def get_raw(uri, &block)
        request_raw Net::HTTP::Get,
                    uri,
                    &block
      end

      # Provides a hash containing necessary headers for API calls.
      def api_headers
        initialize_headers unless @default_headers
        @default_headers
      end

      private

      # Launches a self-configuring generic request,
      # with headers required by the API.
      # Applies filters and idempotency key header if provided.
      # Sends JSON serialization of an object as body if provided.
      #
      # @param +http_client_method+ [Proc] proc representing the HttpClient
      # method to be called for this particular request
      # @param +uri+ [URI] request URI
      # @param +entity+ [Object] object to be JSON-serialized and sent as body
      #        Must include Jsonifier.
      # @param +filter+ [FilterRequest] response entity filtering object
      # @param +id_key+ [String] idempotency key for future response replication
      # @return [Hash] hashed request response JSON body
      def request(http_client_method,
                  uri,
                  entity = nil,
                  filter = nil,
                  id_key = nil)
        validate entity if entity
        apply_filter(uri, filter) if filter
        http_client_method.call(uri) do |request|
          api_headers.each { |k, v| request.add_field(k, v) }
          request.add_field('Idempotency-Key', id_key) if id_key
          request.body = entity.jsonify! if entity
        end
      end

      # Launches a fully customizable generic request.
      # Expects to be given a block to which it yields the
      # request object before execution to be configured.
      #
      # @param +http_method+ [HTTPRequest] method type class
      # @param +uri+ [URI] request URI
      # @return [Hash] hashed request response JSON body
      def request_raw(http_method, uri)
        http_timeout = MangoPay.configuration.http_timeout
        response = Net::HTTP.start(uri.host,
                                   uri.port,
                                   use_ssl: true,
                                   read_timeout: http_timeout) do |http|
          request = http_method.new(uri.request_uri)
          yield request if block_given?
          log_request request
          http.request request
        end
        handle response
      end

      # Validates a provided object as being serializable
      # into an API-acceptable JSON format. Raises if validation fails.
      #
      # @param +entity+ [Object] object meant to be serialized and sent as body
      def validate(entity)
        included_modules = entity.singleton_class.included_modules
        raise 'Request body entity must include Jsonifier module'\
          unless included_modules.include? MangoPay::Jsonifier
      end

      # Applies provided filters as path params
      # to the provided URI.
      #
      # @param +uri+ [URI] URI upon which to apply filters
      # @param +filter+ [FilterRequest] the filtering object
      def apply_filter(uri, filter)
        query = []
        paging = paging_filter(filter.page, filter.per_page)
        sorting = sorting_filter(filter.sort_field, filter.sort_direction)
        others = other_filters(filter)
        query << paging if paging
        query << sorting if sorting
        query << others if others
        uri.query = query.join('&')
      end

      # Builds query string corresponding to paging filter components.
      #
      # @param +page+ [Integer] number of page of results
      # @param +per_page+ [Integer] number of results per page
      # @return [String] query string corresponding to provided values
      def paging_filter(page, per_page)
        return nil unless page && per_page
        paging_filter = {}
        paging_filter['Page'] = page || 1
        paging_filter['Per_Page'] = per_page
        URI.encode_www_form paging_filter
      end

      # Builds query string corresponding to sorting filter components.
      #
      # @param +field+ [SortField] field by which to sort results
      # @param +direction+ [SortDirection] direction to sort results in
      # @return [String] query string corresponding to provided values
      def sorting_filter(field, direction)
        return nil unless field && direction
        sort_param = field.to_s + ':' + direction.to_s
        sorting_filter = { Sort: sort_param }
        URI.encode_www_form sorting_filter
      end

      # Builds query string corresponding to all other filter parameters except
      # the ones for paging and sorting
      #
      # @param +filter+ [FilterRequest] the filtering object
      # @return [String] query string corresponding to provided values
      def other_filters(filter)
        filters = {}
        filters['BeforeDate'] = filter.before_date if filter.before_date
        filters['AfterDate'] = filter.after_date if filter.after_date
        filters['Status'] = filter.status.to_s if filter.status
        filters['Nature'] = filter.nature.to_s if filter.nature
        filters['Type'] = filter.type.to_s if filter.type
        filters['EventType'] = filter.event_type.to_s if filter.event_type
        return nil if filters.empty?
        URI.encode_www_form filters
      end

      # Handles responses from the API.
      def handle(response)
        update_rate_limits response
        log_response response
        code = response.code.to_i
        body_object = code == 204 ? nil : objectify(response.body)
        unless (200..299).cover? code
          raise MangoPay::ResponseError.new response.uri,
                                            response.code,
                                            body_object
        end
        body_object
      end

      # Turns response body into a Hash object if it is JSON-standard.
      def objectify(response_body)
        JSON.parse(response_body)
      rescue
        response_body
      end

      # Handles external responses (from raw HTTP calls).
      def handle_raw(response)
        code = response.code.to_i
        unless (200..299).cover? code
          raise "#{code} #{response.message}: #{response.body}"
        end
        response.body
      end

      # Updates the current environment's rate limit
      # data from response headers.
      #
      # @param +response+ response object from API
      def update_rate_limits(response)
        rate_limits = {}
        response.each_header do |k, v|
          next unless k.include? 'x-ratelimit'
          rate_limits[k] = v.split(', ')
        end
        MangoPay.environment.update_rate_limits rate_limits if rate_limits.any?
      end

      # Logs request data.
      #
      # @param +request+ the request that should be logged
      def log_request(request)
        LOG.debug 'Launching request: {}', request.method
        LOG.debug 'Full URL: {}{}',
                  MangoPay.configuration.root_url, request.path
        request.each_header do |k, v|
          LOG.debug 'Request header: {} -> {}', k, v
        end
        LOG.debug 'Request body: {}', request.body if request.body
      end

      # Logs response data.
      #
      # @param +response+ the response that should be logged
      def log_response(response)
        LOG.debug 'Received response: {} {}', response.code, response.message
        response.header.each do |k, v|
          LOG.debug 'Response header: {} -> {}', k, v
        end
        LOG.debug 'Response body: {}', response.body if response.body
      end

      # Initializes the default headers necessary for API calls.
      #
      # noinspection RubyStringKeysInHashInspection
      def initialize_headers
        auth_token = MangoApi::AuthTokenManager.token
        @default_headers = {
          'User-Agent' => "MangoPay V2 SDK Ruby Bindings v4/#{MangoPay::VERSION}",
          'Authorization' => "#{auth_token['token_type']} "\
                             "#{auth_token['access_token']}",
          'Content-Type' => 'application/json'
        }
        append_user_agent
      end

      def append_user_agent
        @default_headers.update('x_mangopay_client_user_agent' =>
                                JSON.dump(user_agent))
      rescue => e
        @default_headers.update('x_mangopay_client_raw_user_agent' =>
                                user_agent.inspect,
                                error: "#{e} (#{e.class})")
      end

      def user_agent
        {
          bindings_version: MangoPay::VERSION,
          lang: 'ruby',
          lang_version: "#{RUBY_VERSION} p#{RUBY_PATCHLEVEL} "\
                        "(#{RUBY_RELEASE_DATE})",
          platform: RUBY_PLATFORM,
          uname: uname
        }
      end

      def uname
        `uname -a 2>/dev/null`.strip if RUBY_PLATFORM =~ /linux|darwin/i
      rescue Errno::ENOMEM
        'uname lookup failed'
      end
    end
  end
end