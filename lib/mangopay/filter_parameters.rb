module MangoPay
  module FilterParameters

    def self.request(body)
      begin
        body = JSON.load(body)
      rescue MultiJson::LoadError => e
        return body
      end
      filter_hash(body, req_confidential_params)
      JSON.dump(body)
    end

    def self.response(body)
      return '' if body.to_s.empty?

      begin
        body = JSON.load(body)
      rescue MultiJson::LoadError => e
        return body
      end
      filter_hash(body, res_confidential_params)
      JSON.dump(body)
    end

    private

    def self.filter_hash(hash, to_filter)
      hash.each do |k,v|
        if v.is_a?(Hash)
          filter_hash(v, to_filter)
        else
          hash[k] = '[FILTERED]' if to_filter.include?(k)
        end
      end
    end

    def self.res_confidential_params
      @@res_confidential_params ||= [
        'access_token', 'AccessKey', 'IBAN', 'CardRegistrationURL',
        'PreregistrationData', 'RedirectURL', 'RegistrationData',
        'SecureModeRedirectUrl', 'OwnerName', 'OwnerAddress', 'BIC',
        'FirstName', 'LastName', 'Email', 'AddressLine1',
        'AddressLine2',
      ].freeze
    end

    def self.req_confidential_params
      @@req_confidential_params ||= [
        'File', 'IBAN', 'OwnerName', 'OwnerAddress', 'BIC', 'FirstName',
        'LastName', 'Email', 'AddressLine1', 'AddressLine2',
      ].freeze
    end

  end
end
