module MangoPay
  class PayIn < Resource
    include HTTPCalls::Fetch
    include HTTPCalls::Refund

    module Card

      class Web < Resource
        include HTTPCalls::Create
        def self.url(*)
          "#{MangoPay.api_path}/payins/card/#{CGI.escape(class_name.downcase)}"
        end
      end

      class Direct < Resource
        include HTTPCalls::Create
        def self.url(*)
          "#{MangoPay.api_path}/payins/card/#{CGI.escape(class_name.downcase)}"
        end
      end

    end

    module PreAuthorized

      class Direct < Resource
        include HTTPCalls::Create
        def self.url(*)
          "#{MangoPay.api_path}/payins/preauthorized/direct"
        end
      end

    end

    module BankWire

      class Direct < Resource
        include HTTPCalls::Create
        def self.url(*)
          "#{MangoPay.api_path}/payins/bankwire/direct"
        end
      end

    end

  end
end
