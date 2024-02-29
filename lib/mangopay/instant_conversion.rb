module MangoPay

  class InstantConversion < Resource
    include HTTPCalls::Fetch
    include HTTPCalls::Update

    class << self
      def get_rate(debited_currency, credited_currency, params)
        url = "#{MangoPay.api_path}/conversions/rate/#{debited_currency}/#{credited_currency}"
        MangoPay.request(:get, url, params)
      end

      def create(params)
        url = "#{MangoPay.api_path}/conversions/instant-conversion"
        MangoPay.request(:post, url, params)
      end

      def get(id, params)
        url = "#{MangoPay.api_path}/conversions/#{id}"
        MangoPay.request(:get, url, params)
      end
    end
  end
end