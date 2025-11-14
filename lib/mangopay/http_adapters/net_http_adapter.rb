require 'net/http'
require 'securerandom'
require 'benchmark'

module MangoPay
  module HttpAdapters
    # Default HTTP adapter using Net::HTTP.
    class NetHttpAdapter < BaseAdapter
      # Executes a standard HTTP request using Net::HTTP.
      #
      # @return [Net::HTTPResponse] The HTTP response object
      def execute_request(method, uri, params, headers, before_request_proc = nil)
        Net::HTTP.start(
          uri.host,
          uri.port,
          use_ssl: configuration.use_ssl?,
          read_timeout: configuration.http_timeout,
          max_retries: configuration.http_max_retries,
          open_timeout: configuration.http_open_timeout,
          ssl_version: :TLSv1_2
        ) do |http|
          req = Net::HTTP.const_get(method.capitalize).new(uri.request_uri, headers)
          req.body = JSON.dump(params)
          before_request_proc.call(req) if before_request_proc
          perform_request(http, req, uri)
        end
      end

      # Execute a multipart HTTP request for file uploads using Net::HTTP.
      #
      # @return [Net::HTTPResponse] The HTTP response object
      def execute_multipart_request(method, uri, file, file_name, headers)
        # Extract boundary from Content-Type header or generate a new one
        boundary = if headers['Content-Type'] =~ /boundary=(.+)$/
                     $1
                   else
                     "#{SecureRandom.hex}"
                     headers['Content-Type'] = "multipart/form-data; boundary=#{boundary}"
                   end

        # Build multipart body
        multipart_body = []
        multipart_body << "--#{boundary}"
        multipart_body << "Content-Disposition: form-data; name=\"file\"; filename=\"#{file_name}\""
        multipart_body << ""
        multipart_body << file
        multipart_body << "--#{boundary}--"
        multipart_body << ""

        # Join string parts and ensure binary content is preserved
        body = multipart_body.map { |part|
          part.is_a?(String) ? part.force_encoding("ASCII-8BIT") : part
        }.join("\r\n")

        Net::HTTP.start(
          uri.host,
          uri.port,
          use_ssl: configuration.use_ssl?,
          read_timeout: configuration.http_timeout,
          open_timeout: configuration.http_open_timeout,
          max_retries: configuration.http_max_retries,
          ssl_version: :TLSv1_2
        ) do |http|
          req_class = Net::HTTP.const_get(method.capitalize)
          req = req_class.new(uri.request_uri, headers)
          req.body = body
          perform_request(http, req, uri)
        end
      end

      private

      # Perform the actual HTTP request with optional logging.
      #
      # @param http [Net::HTTP] The HTTP connection object
      # @param req [Net::HTTPRequest] The HTTP request object
      # @param uri [URI] The URI object for the request
      #
      # @return [Net::HTTPResponse, nil] The HTTP response or nil on timeout
      def perform_request(http, req, uri)
        if logs_required?
          perform_request_with_log(http, req, uri)
        else
          perform_request_without_log(http, req)
        end
      end

      # Perform request with logging.
      #
      # @param http [Net::HTTP] The HTTP connection object
      # @param req [Net::HTTPRequest] The HTTP request object
      # @param uri [URI] The URI object for the request
      #
      # @return [Net::HTTPResponse, nil] The HTTP response or nil on timeout
      def perform_request_with_log(http, req, uri)
        res, time = nil, nil
        params = FilterParameters.request(req.body)
        if configuration.log_trace_headers
          trace_headers = JSON.dump({ 'Idempotency-Key' => req['Idempotency-Key'], 'x_mangopay_trace-id' => req['x_mangopay_trace-id'] })
          line = "[#{Time.now.iso8601}] #{req.method.upcase} \"#{uri.to_s}\" #{params} #{trace_headers}"
        else
          line = "[#{Time.now.iso8601}] #{req.method.upcase} \"#{uri.to_s}\" #{params}"
        end
        begin
          time = Benchmark.realtime {
            begin
              res = perform_request_without_log(http, req)
            rescue Net::ReadTimeout
              res = nil
            end
          }
          res
        ensure
          line = "#{log_severity(res)} #{line}"
          if time.nil?
            time_log = "[Unknown ms]"
          else
            time_log = "[#{(time * 1000).round(1)}ms]"
          end
          if res.nil?
            params = ''
            line += "\n  #{time_log} 408 Request Timeout #{params}\n"
          else
            params = FilterParameters.response(res.body)
            line += "\n  #{time_log} #{res.code} #{params}\n"
          end
          logger.info { line }
        end
      end

      # Perform request without logging.
      #
      # @param http [Net::HTTP] The HTTP connection object
      # @param req [Net::HTTPRequest] The HTTP request object
      #
      # @return [Net::HTTPResponse] The HTTP response
      def perform_request_without_log(http, req)
        http.request(req)
      end
    end
  end
end