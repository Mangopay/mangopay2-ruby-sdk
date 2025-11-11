module MangoPay

  class Acquiring < Resource
    module PayIn
      module Card
        class Direct < Resource
          def self.create(params, idempotency_key = nil)
            MangoPay.request(:post, "#{MangoPay.api_path}/acquiring/payins/card/direct", params, {}, idempotency_key)
          end
        end
      end

      module ApplePay
        class Direct < Resource
          def self.create(params, idempotency_key = nil)
            MangoPay.request(:post, "#{MangoPay.api_path}/acquiring/payins/payment-methods/applepay", params, {}, idempotency_key)
          end
        end
      end

      module GooglePay
        class Direct < Resource
          def self.create(params, idempotency_key = nil)
            MangoPay.request(:post, "#{MangoPay.api_path}/acquiring/payins/payment-methods/googlepay", params, {}, idempotency_key)
          end
        end
      end

      module Ideal
        class Web < Resource
          def self.create(params, idempotency_key = nil)
            MangoPay.request(:post, "#{MangoPay.api_path}/acquiring/payins/payment-methods/ideal", params, {}, idempotency_key)
          end
        end
      end

      module PayPal
        class Web < Resource
          def self.create(params, idempotency_key = nil)
            MangoPay.request(:post, "#{MangoPay.api_path}/acquiring/payins/payment-methods/paypal", params, {}, idempotency_key)
          end

          def self.create_data_collection(params, idempotency_key = nil)
            MangoPay.request(:post, "#{MangoPay.api_path}/acquiring/payins/payment-methods/paypal/data-collection", params, {}, idempotency_key)
          end
        end
      end
    end

    class Refund < Resource
      def self.create(pay_in_id, params, idempotency_key = nil)
        MangoPay.request(:post, "#{MangoPay.api_path}/acquiring/payins/#{pay_in_id}/refunds", params, {}, idempotency_key)
      end
    end

    class Card < Resource
      def self.get_card_validation(card_id, validation_id)
        MangoPay.request(:get, "#{MangoPay.api_path}/acquiring/cards/#{card_id}/validation/#{validation_id}")
      end
    end
  end
end
