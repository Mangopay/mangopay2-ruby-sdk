module MangoPay

  class Conversion < Resource
    include HTTPCalls::Fetch
    include HTTPCalls::Update

    class << self
      def get_rate(debited_currency, credited_currency, params)
        url = "#{MangoPay.api_path}/conversions/rate/#{debited_currency}/#{credited_currency}"
        MangoPay.request(:get, url, params)
      end

      def create_instant_conversion(params, idempotency_key = nil)
        url = "#{MangoPay.api_path}/conversions/instant-conversion"
        MangoPay.request(:post, url, params, {}, idempotency_key)
      end

      def create_quoted_conversion(params, idempotency_key = nil)
        url = "#{MangoPay.api_path}/conversions/quoted-conversion"
        MangoPay.request(:post, url, params, {}, idempotency_key)
      end

      def get(id, params)
        url = "#{MangoPay.api_path}/conversions/#{id}"
        MangoPay.request(:get, url, params)
      end

      def create_quote(params, idempotency_key = nil)
        url = "#{MangoPay.api_path}/conversions/quote"
        MangoPay.request(:post, url, params, {}, idempotency_key)
      end

      def get_quote(id, params)
        url = "#{MangoPay.api_path}/conversions/quote/#{id}"
        MangoPay.request(:get, url, params)
      end

      def create_client_wallets_quoted_conversion(params, idempotency_key = nil)
        url = "#{MangoPay.api_path}/clients/conversions/quoted-conversion"
        MangoPay.request(:post, url, params, {}, idempotency_key)
      end

      def create_client_wallets_instant_conversion(params, idempotency_key = nil)
        url = "#{MangoPay.api_path}/clients/conversions/instant-conversion"
        MangoPay.request(:post, url, params, {}, idempotency_key)
      end
    end
  end
end