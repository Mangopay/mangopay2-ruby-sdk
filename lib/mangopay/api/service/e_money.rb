require_relative '../uri_provider'
require_relative '../../model/request/currency_request'

module MangoApi

  # Provides API method delegates concerning the +EMoney+ entity
  module EMoney
    class << self
      include UriProvider

      # Retrieves a user's e-money.
      #
      # @param +user_id+ [String] ID of the user whose e-money to retrieve
      # @param +currency+ [CurrencyIso] currency in which to represent results -
      # defaults to EUR.
      # @return [EMoney] the specified user's EMoney entity object
      def of_user(user_id, currency = nil)
        uri = provide_uri(:get_users_e_money, user_id)
        if currency
          response = HttpClient.get_raw(uri) do |request|
            HttpClient.api_headers.each { |k, v| request.add_field(k, v) }
            request.body = CurrencyRequest.new(currency).jsonify!
          end
        else
          response = HttpClient.get(uri)
        end
        parse response
      end

      private

      # Parses a JSON-originating hash into the corresponding
      # EMoney entity object.
      #
      # @param +response+ [Hash] JSON-originating data hash
      # @return [EMoney] corresponding EMoney entity object
      def parse(response)
        MangoModel::EMoney.new.dejsonify response
      end
    end
  end
end