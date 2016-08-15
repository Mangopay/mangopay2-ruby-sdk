module MangoPay
  class FilterRequestParameters

    def initialize(req)
      @body = JSON.load(req.body)
    rescue => e
      @body = req.body
    end

    def body
      return @body unless @body.is_a?(Hash)
      @body.map do |k,v|
        @body[k] = '[FILTERED]' if sensitive_params.include?(k)
      end
      JSON.dump(@body)
    end

    private

    def sensitive_params
      @sensitive_params ||= ['File', 'IBAN'].freeze
    end

  end
end
