module MangoPay
  class PayOut < Resource
    include MangoPay::HTTPCalls::Fetch

    class BankWire < Resource
      include MangoPay::HTTPCalls::Create

      private

      def self.url(*)
        "/v2/#{MangoPay.configuration.client_id}/payouts/bankwire"
      end
    end
  end
end
