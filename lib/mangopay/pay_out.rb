module MangoPay
  class PayOut < Resource
    include HTTPCalls::Fetch

    # See http://docs.mangopay.com/api-references/pay-out-bank-wire/
    class BankWire < Resource
      include HTTPCalls::Create

      def self.url(*)
        "#{MangoPay.api_path}/payouts/bankwire"
      end
    end
  end
end
