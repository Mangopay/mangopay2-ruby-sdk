require_relative 'api_methods'

module MangoApi

  # Provides full contextual URL details for API calls.
  module UriProvider

    # Returns the URI for a given API endpoint. Calls `eval` on the
    # declared API method string if the URL contains parameter placeholders,
    # replacing them with data as passed into the method with the two
    # 'param' params.
    #
    # @param [Symbol] +api_method_symbol+ API endpoint symbol key,
    # as specified in ApiMethods
    # @param [Varargs] +_params+
    #
    # @return [URI] URI for the API endpoint specified by Symbol
    def provide_uri(api_method_symbol,
                    *_params)
      _, unparsed = ApiMethods[api_method_symbol]
      raise("No method declared for key :#{api_method_symbol}") unless unparsed

      parsed_path = unparsed.include?('%') ? eval(unparsed) : unparsed
      config = MangoPay.configuration
      full_url = [config.root_url,
                  config.api_version,
                  config.client_id,
                  parsed_path]
                 .join('/')
      URI(full_url)
    end
  end
end