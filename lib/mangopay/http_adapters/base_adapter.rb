module MangoPay
  module HttpAdapters
    # Base class for HTTP client adapters.
    #
    # Custom adapters must inherit from this class and implement all abstract methods.
    # The adapter is responsible for all HTTP concerns including:
    # - Timeouts (connection and read)
    # - SSL configuration
    # - Retry logic
    # - Header management
    # - Request execution
    #
    class BaseAdapter
      attr_reader :configuration

      def initialize(config)
        @configuration = config
      end

      # Execute a standard HTTP request (GET, POST, PUT, DELETE).
      #
      # @param method [Symbol] HTTP method (:get, :post, :put, :delete)
      # @param uri [URI] The URI object for the request
      # @param params [Hash] Request body parameters (will be JSON-encoded)
      # @param headers [Hash] HTTP headers
      # @param before_request_proc [Proc, nil] Optional proc to call before request execution
      #
      # @return [Object] Response object that responds to:
      #   - code: HTTP status code as string
      #   - body: Response body as string
      #
      # @raise [NotImplementedError] Must be implemented by subclasses
      def execute_request(method, uri, params, headers, before_request_proc = nil)
        raise NotImplementedError, "#{self.class} must implement #execute_request"
      end

      # Execute a multipart HTTP request for file uploads.
      #
      # @param method [Symbol] HTTP method (typically :post or :put)
      # @param uri [URI] The URI object for the request
      # @param file_path [String] Path to the file to upload
      # @param file_name [String] Name of the file
      # @param headers [Hash] HTTP headers
      #
      # @return [Object] Response object that responds to:
      #   - code: HTTP status code as string
      #   - body: Response body as string
      #
      # @raise [NotImplementedError] Must be implemented by subclasses
      def execute_multipart_request(method, uri, file_path, file_name, headers)
        raise NotImplementedError, "#{self.class} must implement #execute_multipart_request"
      end

      private

      def logger
        raise NotImplementedError unless logs_required?
        return @logger if @logger

        if !configuration.logger.nil?
          @logger = configuration.logger
        elsif !configuration.log_file.nil?
          @logger = Logger.new(configuration.log_file)
          @logger.formatter = proc do |_, _, _, msg|
            "#{msg}\n"
          end
        end

        @logger
      end

      def log_severity(res)
        errors = [Net::HTTPClientError, Net::HTTPServerError, Net::HTTPUnknownResponse]
        errors.any? { |klass| res.is_a?(klass) } ? 'E' : 'I'
      end

      def logs_required?
        !configuration.log_file.nil? || !configuration.logger.nil?
      end
    end
  end
end