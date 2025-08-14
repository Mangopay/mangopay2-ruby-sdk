require 'base64'

module MangoPay
  class Client < Resource

    class << self

      # see https://docs.mangopay.com/api-references/client-details/
      def fetch()
        MangoPay.request(:get, url())
      end

      # see https://docs.mangopay.com/api-references/client-details/
      def update(params)
        MangoPay.request(:put, url(), params)
      end

      # see https://docs.mangopay.com/api-references/client-details/
      def upload_logo(file_content_base64, file_path = nil)
        if file_content_base64.nil? && !file_path.nil?
          bts = File.open(file_path, 'rb') { |f| f.read }
          file_content_base64 = Base64.encode64(bts)
        end
        # normally it returns 204 HTTP code on success
        begin
          MangoPay.request(:put, url() + '/logo', {'File' => file_content_base64})
        rescue ResponseError => ex
          raise ex unless ex.code == '204'
        end
      end

      # Fetch all your client wallets;
      # +funds_type+ may be:
      #   - nil: all wallets
      #   - 'fees': fees wallets
      #   - 'credit': credit wallets
      # see https://docs.mangopay.com/api-references/client-wallets/
      def fetch_wallets(funds_type = nil)
        MangoPay.request(:get, url() + "/wallets/#{funds_type}")
      end

      # Fetch one of your client wallets (fees or credit) with a particular currency;
      # +funds_type+ may be:
      #   - nil: all wallets
      #   - 'fees': fees wallets
      #   - 'credit': credit wallets
      # +currency_iso_code+ is currncy ISO code
      # see https://docs.mangopay.com/api-references/client-wallets/
      def fetch_wallet(funds_type, currency_iso_code)
        method = :get
        path = url() + "/wallets/#{funds_type}/#{currency_iso_code}"
        yield method, path if block_given?
        MangoPay.request(method, path)
      end

      # Fetch transactions for all your client wallets.
      # Optional +filters+ hash: see MangoPay::Transaction.fetch
      # See https://docs.mangopay.com/api-references/client-wallets/
      def fetch_wallets_transactions(filters = {})
        MangoPay.request(:get, url() + "/transactions", {}, filters)
      end

      # Fetch transactions for one of your client wallets (fees or credit) with a particular currency;
      # +funds_type+ may be:
      #   - nil: all wallets
      #   - 'fees': fees wallets
      #   - 'credit': credit wallets
      # +currency_iso_code+ is currncy ISO code
      # Optional +filters+ hash: see MangoPay::Transaction.fetch
      # See https://docs.mangopay.com/api-references/client-wallets/
      def fetch_wallet_transactions(funds_type, currency_iso_code, filters = {})
        MangoPay.request(:get, url() + "/wallets/#{funds_type}/#{currency_iso_code}/transactions", {}, filters)
      end

      def create_bank_account(params)
        MangoPay.request(:post, url() + "/bankaccounts/iban", params)
      end

      def create_payout(params)
        method = :post
        path = url() + "/payouts"
        yield method, path, params if block_given?
        MangoPay.request(method, path, params)
      end

      def create_bank_wire_direct_pay_in(params, idempotency_key = nil)
        MangoPay.request(:post, url() + "/payins/bankwire/direct", params, {}, idempotency_key)
      end

    end
  end
end
