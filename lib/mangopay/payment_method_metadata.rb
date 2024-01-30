module MangoPay
  class PaymentMethodMetadata < Resource
    include HTTPCalls::Fetch
    include HTTPCalls::Update

    class << self
      def get_metadata(metadata)
        url = "#{MangoPay.api_path}/payment-methods/metadata"
        MangoPay.request(:post, url, metadata)
      end
    end
  end
end