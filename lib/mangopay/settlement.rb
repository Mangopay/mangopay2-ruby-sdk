module MangoPay

  class Settlement < Resource
    class << self
      def upload(file, idempotency_key = nil)
        url = "#{MangoPay.api_path_v3}/payins/intents/settlements"
        MangoPay.request_multipart(:post, url, file, 'settlement_sample.csv', idempotency_key)
      end

      def get(settlement_id)
        url = "#{MangoPay.api_path_v3}/payins/intents/settlements/#{settlement_id}"
        MangoPay.request(:get, url)
      end

      def update(settlement_id, file, idempotency_key = nil)
        url = "#{MangoPay.api_path_v3}/payins/intents/settlements/#{settlement_id}"
        MangoPay.request_multipart(:post, url, file, 'settlement_sample.csv', idempotency_key)
      end
    end
  end
end
