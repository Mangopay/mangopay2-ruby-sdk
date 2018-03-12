require_relative '../uri_provider'
require_relative '../../model/report_filter'

module MangoApi

  # Provides API method delegates concerning the +Report+ entity
  module Reports
    class << self
      include UriProvider

      # Requests creation of a transaction report.
      # Yields a +ReportFilter+ object for caller to specify
      # filtering parameters in a provided block.
      #
      # +Report+ properties:
      # * Optional
      #   * tag
      #   * callback_url
      #   * download_format
      #   * sort
      #   * preview
      #   * columns
      #
      # Available +columns+ values: Alias, AuthorId,
      # BankAccountId, BankWireRef, CardId, CardType, Country,
      # CreationDate, CreditedFundsAmount, CreditedFundsCurrency,
      # CreditedUserId, CreditedWalletId, Culture, DebitedFundsAmount,
      # DebitedFundsCurrency, DebitedWalletId, DeclaredDebitedFundsAmount,
      # DeclaredDebitedFundsCurrency, DeclaredFeesAmount, DeclaredFeesCurrency,
      # ExecutionDate, ExecutionType, ExpirationDate, FeesAmount, FeesCurrency,
      # Id, Nature, PaymentType, PreauthorizationId, ResultCode, ResultMessage,
      # Status, Tag, Type, WireReference
      #
      # Allowed +ReportFilter+ params:
      # * after_date
      # * before_date
      # * type
      # * status
      # * nature
      # * min_debited_funds_amount
      # * min_debited_funds_currency
      # * max_debited_funds_amount
      # * max_debited_funds_currency
      # * min_fees_amount
      # * min_fees_currency
      # * max_fees_amount
      # * max_fees_currency
      # * author_id
      # * wallet_id
      #
      # @param +report+ [Report] model object of the report to be created
      # @return [Report] the newly-created Report entity object
      def create_for_transactions(report)
        uri = provide_uri(:create_transaction_report)
        report.filters = ReportFilter.new unless report.filters
        yield report.filters if block_given?
        response = HttpClient.post(uri, report)
        parse response
      end

      # Requests creation of a wallet report.
      # Yields a +ReportFilter+ object for caller to specify
      # filtering parameters in a provided block.
      #
      # +Report+ properties:
      # * Optional
      #   * tag
      #   * callback_url
      #   * download_format
      #   * sort
      #   * preview
      #   * columns
      #
      # Available +columns+ values: Id, Tag, CreationDate, Owners, Description,
      # BalanceAmount, BalanceCurrency, Currency, FundsType
      #
      # Allowed +FilterRequest+ params:
      # * after_date
      # * before_date
      # * owner_id
      # * currency
      # * min_balance_amount
      # * min_balance_currency
      # * max_balance_amount
      # * max_balance_currency
      #
      # @param +report+ [Report] model object of the report to be created
      # @return [Report] the newly-created Report entity object
      def create_for_wallets(report)
        uri = provide_uri(:create_wallet_report)
        report.filters = ReportFilter.new unless report.filters
        yield report.filters if block_given?
        response = HttpClient.post(uri, report)
        parse response
      end

      # Retrieves a report entity.
      #
      # @param +id+ [String] ID of the report to retrieve
      # @return [Report] the requested Report entity object
      def get(id)
        uri = provide_uri(:get_report, id)
        response = HttpClient.get(uri)
        parse response
      end

      # Retrieves report entities. Allows configuration of paging and
      # sorting parameters by yielding a filtering object to a provided
      # block. When no filters are specified, will retrieve the first
      # page of 10 newest results.
      #
      # Allowed +FilterRequest+ params:
      # * page
      # * per_page
      # * sort_field and sort_direction
      # * before_date
      # * after_date
      #
      # @return [Array] corresponding Report entity objects
      def all
        uri = provide_uri(:get_reports)
        filter_request = nil
        yield filter_request = FilterRequest.new if block_given?
        results = HttpClient.get(uri, filter_request)
        parse_results results
      end

      private

      # Parses an array of JSON-originating hashes into the corresponding
      # Report entity objects.
      #
      # @param +results+ [Array] JSON-originating data hashes
      # @return [Array] parsed Report entity objects
      def parse_results(results)
        results.collect do |entity|
          parse entity
        end
      end

      # Parses a JSON-originating hash into the corresponding
      # Report entity object.
      #
      # @param +response+ [Hash] JSON-originating data hash
      # @return [Report] corresponding Report entity object
      def parse(response)
        MangoModel::Report.new.dejsonify response
      end
    end
  end
end