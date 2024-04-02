module MangoPay

  # See http://docs.mangopay.com/api-references/payins/
  class PayIn < Resource
    include HTTPCalls::Fetch
    include HTTPCalls::Refund

    # Fetches list of refunds belonging to the given +pay_in_id+.
    #
    # Optional +filters+ is a hash accepting following keys:
    # - +page+, +per_page+, +sort+: pagination and sorting params (see MangoPay::HTTPCalls::Fetch::ClassMethods#fetch)
    # - +Status+: TransactionStatus {CREATED, SUCCEEDED, FAILED}
    # - +ResultCode+: string representing the transaction result
    def self.refunds(pay_in_id, filters = {})
      url = url(pay_in_id) + '/refunds'
      MangoPay.request(:get, url, {}, filters)
    end

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

        def self.create_pre_authorized_deposit_pay_in(params, idempotency_key = nil)
          MangoPay.request(:post, "#{MangoPay.api_path}/payins/deposit-preauthorized/direct/full-capture", params, {}, idempotency_key)
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

      class ExternalInstruction < Resource
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
      # # <b>DEPRECATED</b>: 'create' function is now deprecated.
      # Please use the 'create_v2' function - MangoPay::PayIn::PayPal::Web.create_new(params)
      class Web < Resource
        include HTTPCalls::Create

        def self.url(*)
          "#{MangoPay.api_path}/payins/paypal/#{CGI.escape(class_name.downcase)}"
        end

        def self.create_v2(params, idempotency_key = nil)
          MangoPay.request(:post, "#{MangoPay.api_path}/payins/payment-methods/paypal", params, {}, idempotency_key)
        end

        # Add tracking information to a PayPal PayIn (add the tracking number and carrier for LineItems shipments.)
        # Caution – Tracking information cannot be edited
        # You can’t modify the TrackingNumber, Carrier, or NotifyBuyer once added.
        # You can only send a unique tracking number once.
        def self.add_paypal_tracking_information(pay_in_id, params, idempotency_key = nil)
          MangoPay.request(:put, "#{MangoPay.api_path}/payins/#{pay_in_id}/trackings", params, {}, idempotency_key)
        end
      end

    end

    module Payconiq

      class Web < Resource
        include HTTPCalls::Create

        def self.url(*)
          "#{MangoPay.api_path}/payins/payconiq/#{CGI.escape(class_name.downcase)}"
        end
      end

    end

    module ApplePay
      class Direct < Resource
        include HTTPCalls::Create

        def self.url(*)
          "#{MangoPay.api_path}/payins/applepay/#{CGI.escape(class_name.downcase)}"
        end
      end
    end

    module GooglePay
      class Direct < Resource
        include HTTPCalls::Create

        def self.url(*)
          "#{MangoPay.api_path}/payins/payment-methods/googlepay"
        end
      end
    end

    module Mbway
      class Web < Resource
        include HTTPCalls::Create

        def self.url(*)
          "#{MangoPay.api_path}/payins/payment-methods/mbway"
        end
      end
    end

    module Multibanco
      class Web < Resource
        include HTTPCalls::Create

        def self.url(*)
          "#{MangoPay.api_path}/payins/payment-methods/multibanco"
        end
      end
    end

    module Blik
      class Web < Resource
        include HTTPCalls::Create

        def self.url(*)
          "#{MangoPay.api_path}/payins/payment-methods/blik"
        end
      end
    end

    module Satispay
      class Web < Resource
        include HTTPCalls::Create

        def self.url(*)
          "#{MangoPay.api_path}/payins/payment-methods/satispay"
        end
      end
    end

    module Klarna
      class Web < Resource
        include HTTPCalls::Create

        def self.url(*)
          "#{MangoPay.api_path}/payins/payment-methods/klarna"
        end
      end
    end

    module Ideal
      class Web < Resource
        include HTTPCalls::Create

        def self.url(*)
          "#{MangoPay.api_path}/payins/payment-methods/ideal"
        end
      end
    end

    module Giropay
      class Web < Resource
        include HTTPCalls::Create

        def self.url(*)
          "#{MangoPay.api_path}/payins/payment-methods/giropay"
        end
      end
    end

    module RecurringPayments
      class Recurring < Resource
        include HTTPCalls::Create
        include HTTPCalls::Fetch
        include HTTPCalls::Update

        def self.url(*args)
          if args.any?
            "#{MangoPay.api_path}/recurringpayinregistrations/#{args.first}"
          else
            "#{MangoPay.api_path}/recurringpayinregistrations"
          end
        end
      end

      class CIT < Resource
        include HTTPCalls::Create

        def self.url(*)
          "#{MangoPay.api_path}/payins/recurring/card/direct"
        end
      end

      class MIT < Resource
        include HTTPCalls::Create

        def self.url(*)
          "#{MangoPay.api_path}/payins/recurring/card/direct"
        end
      end
    end

  end
end
