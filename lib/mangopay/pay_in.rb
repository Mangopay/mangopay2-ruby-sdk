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

        def self.extended(pay_in_id)
          MangoPay.request(:get, extended_url(pay_in_id), {}, {})
        end

        # See https://docs.mangopay.com/endpoints/v2.01/payins#e847_view-card-details-for-a-payin-web
        # example: data = MangoPay::PayIn::Card::Web.extended(12639078)
        def self.extended_url(pay_in_id)
          escaped_pay_in_id = CGI.escape(pay_in_id.to_s)
          "#{MangoPay.api_path}/payins/card/web/#{escaped_pay_in_id}/extended"
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

    module PayPal

      # See https://docs.mangopay.com/api-references/payins/paypal-payin/
      class Web < Resource
        include HTTPCalls::Create
        def self.url(*)
          "#{MangoPay.api_path}/payins/paypal/#{CGI.escape(class_name.downcase)}"
        end
      end

    end

  end
end
