require_relative '../uri_provider'

module MangoApi

  # Provides API method delegates concerning the +PayIn+ entity
  module PayIns
    class << self
      include UriProvider

      # Creates a new pay-in entity of +PaymentType::CARD+
      # and +ExecutionType::WEB+.
      #
      # +CardWebPayIn+ properties:
      # * Required
      #   * author_id
      #   * debited_funds
      #   * fees
      #   * return_url
      #   * credited_wallet_id
      #   * card_type
      #   * culture
      # * Optional
      #   * tag
      #   * credited_user_id
      #   * secure_mode
      #   * template_url_options
      #   * statement_descriptor
      #
      # @param +pay_in+ [CardWebPayIn] the pay-in data model object
      # @param +id_key+ [String] idempotency key for future response replication
      # @return [CardWebPayIn] the newly-created pay-in entity object
      def create_card_web(pay_in, id_key = nil)
        uri = provide_uri(:create_card_web_pay_in)
        response = HttpClient.post(uri, pay_in, id_key)
        parse response
      end

      # Creates a new pay-in entity of +PaymentType::CARD+
      # and +ExecutionType::DIRECT+.
      #
      # +CardDirectPayIn+ properties:
      # * Required
      #   * author_id
      #   * credited_wallet_id
      #   * debited_funds
      #   * fees
      #   * secure_mode_return_url
      #   * card_id
      # * Optional
      #   * tag
      #   * credited_user_id
      #   * secure_mode
      #   * statement_descriptor
      #
      # @param +pay_in+ [CardDirectPayIn] the pay-in data model object
      # @param +id_key+ [String] idempotency key for future response replication
      # @return [CardDirectPayIn] the newly-created pay-in entity object
      def create_card_direct(pay_in, id_key = nil)
        uri = provide_uri(:create_card_direct_pay_in)
        response = HttpClient.post(uri, pay_in, id_key)
        parse response
      end

      # Creates a new pay-in entity of +PaymentType::PREAUTHORIZED+
      # and +ExecutionType::DIRECT+
      #
      # +CardPreAuthorizedPayIn+ properties:
      # * Required
      #   * author_id
      #   * credited_wallet_id
      #   * debited_funds
      #   * fees
      #   * preauthorization_id
      # * Optional
      #   * tag
      #   * credited_user_id
      #
      # @param +pay_in+ [CardPreAuthorizedPayIn] the pay-in data model object
      # @param +id_key+ [String] idempotency key for future response replication
      # @return [CardPreAuthorizedPayIn] the newly-created pay-in entity object
      def create_card_pre_authorized(pay_in, id_key = nil)
        uri = provide_uri(:create_card_pre_authorized_pay_in)
        response = HttpClient.post(uri, pay_in, id_key)
        parse response
      end

      # Creates a new pay-in entity of +PaymentType::BANK_WIRE+
      # and +ExecutionType::DIRECT+.
      #
      # +BankWireDirectPayIn+ properties:
      # * Required
      #   * author_id
      #   * credited_wallet_id
      #   * declared_debited_funds
      #   * declared_fees
      # * Optional
      #   * tag
      #   * credited_user_id
      #
      # @param +pay_in+ [BankWireDirectPayIn] the pay-in data model object
      # @param +id_key+ [String] idempotency key for future response replication
      # @return [BankWireDirectPayIn] the newly-created pay-in entity object
      def create_bank_wire_direct(pay_in, id_key = nil)
        uri = provide_uri(:create_bank_wire_direct_pay_in)
        response = HttpClient.post(uri, pay_in, id_key)
        parse response
      end

      # Creates a new pay-in entity of +PaymentType::BANK_WIRE+
      # and +ExecutionType::DIRECT+. This method can be used
      # to add funds to the environment's client's wallets.
      #
      # +BankWireDirectPayIn+ properties:
      # * Required
      #   * credited_wallet_id
      #   * declared_debited_funds
      #   * declared_fees
      # * Optional
      #   * tag
      #
      # @param +pay_in+ [BankWireDirectPayIn] the pay-in data model object
      # Note: The ID field must contain one of the automatically-generated
      # ClientWallet IDs specific to the current environment's client
      # (+FUNDS_TYPE+ _ +CURRENCY+ - FEES_EUR, CREDIT_USD etc.)
      # @param +id_key+ [String] idempotency key for future response replication
      def create_client_bank_wire_direct(pay_in, id_key = nil)
        uri = provide_uri(:create_client_bank_wire_direct_pay_in)
        response = HttpClient.post(uri, pay_in, id_key)
        parse response
      end

      # Creates a new pay-in entity of +PaymentType::DIRECT_DEBIT+
      # and +ExecutionType::WEB+.
      #
      # +DirectDebitWebPayIn+ properties:
      # * Required
      #   * author_id
      #   * debited_funds
      #   * fees
      #   * return_url
      #   * credited_wallet_id
      #   * direct_debit_type
      #   * culture
      # * Optional
      #   * tag
      #   * credited_user_id
      #   * secure_mode
      #   * template_url_options
      #
      # @param +pay_in+ [DirectDebitWebPayIn] the pay-in data model object
      # @param +id_key+ [String] idempotency key for future response replication
      # @return [DirectDebitWebPayIn] the newly-created pay-in entity object
      def create_direct_debit_web(pay_in, id_key = nil)
        uri = provide_uri(:create_direct_debit_web_pay_in)
        response = HttpClient.post(uri, pay_in, id_key)
        parse response
      end

      # Creates a new pay-in entity of +PaymentType::DIRECT_DEBIT+
      # and +ExecutionType::DIRECT+.
      #
      # +DirectDebitDirectPayIn+ properties:
      # * Required
      #   * author_id
      #   * credited_wallet_id
      #   * debited_funds
      #   * fees
      #   * mandate_id
      # * Optional
      #   * tag
      #   * credited_user_id
      #   * statement_descriptor
      #
      # @param +pay_in+ [DirectDebitDirectPayIn] the pay-in data model object
      # @param +id_key+ [String] idempotency key for future response replication
      # @return [DirectDebitDirectPayIn] the newly-created pay-in entity object
      def create_direct_debit_direct(pay_in, id_key = nil)
        uri = provide_uri(:create_direct_debit_direct_pay_in)
        response = HttpClient.post(uri, pay_in, id_key)
        parse response
      end


      # Creates a new pay-in entity of +PaymentType::PAYPAL+
      # and +ExecutionType::WEB+.
      #
      # +PaypalWebPayIn+ properties:
      # * Required
      #   * author_id
      #   * debited_funds
      #   * fees
      #   * return_url
      #   * credited_wallet_id
      #   * direct_debit_type
      #   * shipping_address
      #   * paypal_buyer_account_email
      #   * culture
      # * Optional
      #   * tag
      #   * credited_user_id
      #   * secure_mode
      #   * template_url_options
      #
      # @param +pay_in+ [PaypalWebPayIn] the pay-in data model object
      # @param +id_key+ [String] idempotency key for future response replication
      # @return [PaypalWebPayIn] the newly-created pay-in entity object
      def create_paypal_web(pay_in, id_key = nil)
        uri = provide_uri(:create_paypal_web_pay_in)
        response = HttpClient.post(uri, pay_in, id_key)
        parse response
      end

      # Creates a new pay-in entity of +PaymentType::APPLE_PAY+
      # and +ExecutionType::DIRECT+.
      #
      # +ApplePayPayIn+ properties:
      # * Required
      #   * author_id
      #   * credited_wallet_id
      #   * debited_funds
      #   * fees
      #   * transaction_id
      #   * network
      #   * token_data
      # * Optional
      #   * tag
      #   * credited_user_id
      #   * statement_descriptor
      #
      # @param +pay_in+ [ApplePayPayIn] the pay-in data model object
      # @param +id_key+ [String] idempotency key for future response replication
      # @return [ApplePayPayIn] the newly-created pay-in entity object
      def create_apple_pay_direct(pay_in, id_key = nil)
        uri = provide_uri(:create_apple_pay_pay_in)
        json = pay_in.jsonify!
        payment_data = pay_in.payment_data.to_json
        new_json = json[0..json.length - 2] + "," + "\"PaymentData\":" + payment_data + "}"
        response = HttpClient.post_raw(uri) do |request|
          HttpClient.api_headers.each { |k, v| request.add_field(k, v) }
          request.add_field('Idempotency-Key', id_key) if id_key
          request.body = new_json
        end
        parse response
      end

      # Retrieves a pay-in entity.
      #
      # @param +id+ [String] ID of the pay-in to be retrieved
      # @return [PayIn] the requested entity object
      def get(id)
        uri = provide_uri(:get_pay_in, id)
        response = HttpClient.get(uri)
        parse response
      end

      # Retrieves a detailed view of details concerning the
      # card used to process a Web payment.
      #
      # @param +pay_in_id+ [String] ID of the Card Web Pay-In entity
      # for which to retrieve extended details view
      # @return [PayInWebExtendedView] Object containing extended
      # details about the card
      def extended_card_view(pay_in_id)
        uri = provide_uri(:get_extended_card_view, pay_in_id)
        response = HttpClient.get(uri)
        parse_card_view response
      end

      private

      # Parses an array of JSON-originating hashes into the corresponding
      # PayIn entity objects.
      #
      # @param +results+ [Array] JSON-originating data hashes
      # @return [Array] parsed PayIn entity objects
      def parse_results(results)
        results.collect do |entity|
          parse entity
        end
      end

      # Parses a JSON-originating hash into the corresponding
      # PayIn entity object.
      #
      # @param +response+ [Hash] JSON-originating data hash
      # @return [PayIn] corresponding PayIn entity object
      def parse(response)
        type = pay_in_type(response)
        type.new.dejsonify response
      end

      # Asserts the type of pay-in represented by a hash
      #
      # @param +hash+ [Hash] source hash
      # @return [Class] type of pay-in represented by the hash
      def pay_in_type(hash)
        if hash['PaymentType'] == MangoModel::PayInPaymentType::CARD.to_s\
          && hash['ExecutionType'] == MangoModel::PayInExecutionType::WEB.to_s
          MangoModel::CardWebPayIn
        elsif hash['PaymentType'] == MangoModel::PayInPaymentType::CARD.to_s\
          && hash['ExecutionType'] == MangoModel::PayInExecutionType::DIRECT.to_s
          MangoModel::CardDirectPayIn
        elsif hash['PaymentType'] == MangoModel::PayInPaymentType::PREAUTHORIZED.to_s\
          && hash['ExecutionType'] == MangoModel::PayInExecutionType::DIRECT.to_s
          MangoModel::CardPreAuthorizedPayIn
        elsif hash['PaymentType'] == MangoModel::PayInPaymentType::BANK_WIRE.to_s\
         && hash['ExecutionType'] == MangoModel::PayInExecutionType::DIRECT.to_s
          MangoModel::BankWireDirectPayIn
        elsif hash['PaymentType'] == MangoModel::PayInPaymentType::BANK_WIRE.to_s\
         && hash['ExecutionType'] == MangoModel::PayInExecutionType::EXTERNAL_INSTRUCTION.to_s
          MangoModel::BankWireExternalInstructionPayIn
        elsif hash['PaymentType'] == MangoModel::PayInPaymentType::DIRECT_DEBIT.to_s\
         && hash['ExecutionType'] == MangoModel::PayInExecutionType::WEB.to_s
          MangoModel::DirectDebitWebPayIn
        elsif hash['PaymentType'] == MangoModel::PayInPaymentType::DIRECT_DEBIT.to_s\
         && hash['ExecutionType'] == MangoModel::PayInExecutionType::DIRECT.to_s
          MangoModel::DirectDebitDirectPayIn
        elsif hash['PaymentType'] == MangoModel::PayInPaymentType::PAYPAL.to_s\
         && hash['ExecutionType'] == MangoModel::PayInExecutionType::WEB.to_s
          MangoModel::PaypalWebPayIn
        elsif hash['PaymentType'] == MangoModel::PayInPaymentType::APPLEPAY.to_s\
         && hash['ExecutionType'] == MangoModel::PayInExecutionType::DIRECT.to_s
          MangoModel::ApplePayPayIn
        end
      end

      def parse_card_view(response)
        MangoModel::PayInWebExtendedView.new.dejsonify response
      end
    end
  end
end