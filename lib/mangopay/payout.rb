module MangoPay
  class PayOut < Resource
    include MangoPay::HTTPCalls::Fetch

    class BankWire < Resource
      include MangoPay::HTTPCalls::Create

      private

      def self.url(id = nil)
        "/v2/#{MangoPay.configuration.client_id}/payouts/bank-wire"
      end
    end
  end
end
