module MangoPay
  class PayIn < Resource
    include MangoPay::HTTPCalls::Fetch
    include MangoPay::HTTPCalls::Refund

    module Card

      class Web < Resource
        include MangoPay::HTTPCalls::Create
        def self.url(*)
          "/v2/#{MangoPay.configuration.client_id}/payins/card/#{CGI.escape(class_name.downcase)}"
        end
      end

      class Direct < Resource
        include MangoPay::HTTPCalls::Create
        def self.url(*)
          "/v2/#{MangoPay.configuration.client_id}/payins/card/#{CGI.escape(class_name.downcase)}"
        end
      end

    end

    module PreAuthorized

      class Direct < Resource
        include MangoPay::HTTPCalls::Create
        def self.url(*)
          "/v2/#{MangoPay.configuration.client_id}/payins/preauthorized/direct"
        end
      end

    end

    module BankWire

      class Direct < Resource
        include MangoPay::HTTPCalls::Create
        def self.url(*)
          "/v2/#{MangoPay.configuration.client_id}/payins/bankwire/direct"
        end
      end

    end

  end
end
