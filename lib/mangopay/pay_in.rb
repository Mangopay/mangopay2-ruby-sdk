module MangoPay

  # See http://docs.mangopay.com/api-references/payins/
  class PayIn < Resource
    include HTTPCalls::Fetch
    include HTTPCalls::Refund

    module Card

      # See http://docs.mangopay.com/api-references/payins/payins-card-web/
      class Web < Resource
        include HTTPCalls::Create
        def self.url(*)
          "#{MangoPay.api_path}/payins/card/#{CGI.escape(class_name.downcase)}"
        end
      end

      # See http://docs.mangopay.com/api-references/payins/payindirectcard/
      class Direct < Resource
        include HTTPCalls::Create
        def self.url(*)
          "#{MangoPay.api_path}/payins/card/#{CGI.escape(class_name.downcase)}"
        end
      end

    end

    module PreAuthorized

      # See http://docs.mangopay.com/api-references/payins/preauthorized-payin/
      class Direct < Resource
        include HTTPCalls::Create
        def self.url(*)
          "#{MangoPay.api_path}/payins/preauthorized/direct"
        end
      end

    end

    module BankWire

      # See http://docs.mangopay.com/api-references/payins/payinbankwire/
      class Direct < Resource
        include HTTPCalls::Create
        def self.url(*)
          "#{MangoPay.api_path}/payins/bankwire/direct"
        end
      end

    end

    module DirectDebit

      # See http://docs.mangopay.com/api-references/payins/direct-debit-pay-in-web/
      class Web < Resource
        include HTTPCalls::Create
        def self.url(*)
          "#{MangoPay.api_path}/payins/directdebit/#{CGI.escape(class_name.downcase)}"
        end
      end

      # See https://docs.mangopay.com/api-references/payins/direct-debit-pay-in-direct/
      class Direct < Resource
        include HTTPCalls::Create
        def self.url(*)
          "#{MangoPay.api_path}/payins/directdebit/#{CGI.escape(class_name.downcase)}"
        end
      end

    end

  end
end
