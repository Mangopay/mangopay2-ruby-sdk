module MangoPay
  class PayOut < Resource
    include HTTPCalls::Fetch

    class BankWire < Resource
      include HTTPCalls::Create

      def self.url(*)
        "#{MangoPay.api_path}/payouts/bankwire"
      end
    end
  end
end
