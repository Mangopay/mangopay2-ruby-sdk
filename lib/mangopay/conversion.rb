module MangoPay

  class Conversion < Resource
    include HTTPCalls::Fetch
    include HTTPCalls::Update

    class << self
      def get_rate(debited_currency, credited_currency, params)
        url = "#{MangoPay.api_path}/conversions/rate/#{debited_currency}/#{credited_currency}"
        MangoPay.request(:get, url, params)
      end

      def create_instant_conversion(params)
        url = "#{MangoPay.api_path}/conversions/instant-conversion"
        MangoPay.request(:post, url, params)
      end

      def create_quoted_conversion(params)
        url = "#{MangoPay.api_path}/conversions/quoted-conversion"
        MangoPay.request(:post, url, params)
      end

      def get(id, params)
        url = "#{MangoPay.api_path}/conversions/#{id}"
        MangoPay.request(:get, url, params)
      end

      def create_quote(params)
        url = "#{MangoPay.api_path}/conversions/quote"
        MangoPay.request(:post, url, params)
      end

      def get_quote(id, params)
        url = "#{MangoPay.api_path}/conversions/quote/#{id}"
        MangoPay.request(:get, url, params)
      end
    end
  end
end