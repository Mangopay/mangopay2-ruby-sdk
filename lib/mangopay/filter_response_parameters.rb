module MangoPay
  class FilterResponseParameters

    def initialize(res)
      @body = res.body.to_s.empty? ? {} : JSON.load(res.body.to_s)
    end

    def body
      return '' if @body.empty?
      @body.map do |k,v|
        @body[k] = '[FILTERED]' if sensitive_params.include?(k)
      end
      JSON.dump(@body)
    end

    private

    def sensitive_params
      @sensitive_params ||= [
        'access_token', 'AccessKey', 'IBAN', 'PreregistrationData', 'RedirectURL'
      ].freeze
    end

  end
end
