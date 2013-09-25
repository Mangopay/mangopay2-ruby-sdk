module MangoPay

  # Generic error superclass for MangoPay specific errors.
  # Currently never instantiated directly.
  # Currently only single subclass used.
  class Error < StandardError
  end

  # Thrown from any MangoPay API call whenever
  # it returns response with HTTP code != 200.
  class ResponseError < Error

    attr_reader :request_url, :code, :details

    def initialize(request_url, code, details)
      @request_url, @code, @details = request_url, code, details
      super(message) if message
    end

    def message; @details['Message']; end
    def type;    @details['Type']; end
    def errors;  @details['errors']; end
  end
end
