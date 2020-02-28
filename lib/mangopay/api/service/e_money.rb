require_relative '../uri_provider'
require_relative '../../model/request/currency_request'

module MangoApi

  # Provides API method delegates concerning the +EMoney+ entity
  module EMoney
    class << self
      include UriProvider

      # Retrieves a user's e-money for year.
      #
      # @param +user_id+ [String] ID of the user whose e-money to retrieve
      # @param +year+ [Int] year for which to retrieve e-money
      # @param +currency+ [CurrencyIso] currency in which to represent results -
      # defaults to EUR.
      # @return [EMoney] the specified user's EMoney entity object
      def of_user_year(user_id, year, currency = nil)
        uri = provide_uri(:get_users_e_money_year, user_id, year)
        if currency
          response = HttpClient.get_raw(uri) do |request|
            HttpClient.api_headers.each {|k, v| request.add_field(k, v)}
            request.body = CurrencyRequest.new(currency).jsonify!
          end
        else
          response = HttpClient.get(uri)
        end
        parse response
      end

      # Retrieves a user's e-money for year/month.
      #
      # @param +user_id+ [String] ID of the user whose e-money to retrieve
      # @param +year+ [Int] year for which to retrieve e-money
      # @param +month+ [Int] month for which to retrieve e-money
      # @param +currency+ [CurrencyIso] currency in which to represent results -
      # defaults to EUR.
      # @return [EMoney] the specified user's EMoney entity object
      def of_user_month(user_id, year, month, currency = nil)
        uri = provide_uri(:get_users_e_money_month, user_id, year, month)
        if currency
          response = HttpClient.get_raw(uri) do |request|
            HttpClient.api_headers.each {|k, v| request.add_field(k, v)}
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