require 'date'
require_relative 'entity/entity_base'
require_relative 'enum/country_iso'
require_relative 'enum/person_type'
require_relative 'enum/legal_person_type'
require_relative 'enum/income_range'
require_relative 'enum/kyc_level'
require_relative 'enum/deposit_type'
require_relative 'enum/currency_iso'
require_relative 'enum/funds_type'
require_relative 'enum/platform_type'
require_relative 'enum/account_type'
require_relative 'enum/transaction_type'
require_relative 'enum/transaction_nature'
require_relative 'enum/transaction_status'
require_relative 'enum/pay_in_payment_type'
require_relative 'enum/pay_in_execution_type'
require_relative 'enum/card_type'
require_relative 'enum/secure_mode'
require_relative 'enum/culture_code'
require_relative 'enum/card_status'
require_relative 'enum/card_validity'
require_relative 'enum/pre_authorization_status'
require_relative 'enum/pre_authorization_execution_type'
require_relative 'enum/payment_status'
require_relative 'enum/direct_debit_type'
require_relative 'enum/mandate_scheme'
require_relative 'enum/mandate_status'
require_relative 'enum/mandate_type'
require_relative 'enum/mandate_execution_type'
require_relative 'enum/pay_out_payment_type'
require_relative 'enum/kyc_doc_refused_reason_type'
require_relative 'enum/kyc_document_type'
require_relative 'enum/document_status'
require_relative 'enum/natural_user_capacity'
require_relative 'enum/ubo_declaration_status'
require_relative 'enum/ubo_declaration_refused_reason_type'
require_relative 'enum/declared_ubo_status'
require_relative 'enum/declared_ubo_refused_reason_type'
require_relative 'enum/hook_validity'
require_relative 'enum/event_type'
require_relative 'enum/refund_reason_type'
require_relative 'enum/dispute_type'
require_relative 'enum/dispute_reason_type'
require_relative 'enum/dispute_status'
require_relative 'enum/dispute_doc_refused_reason_type'
require_relative 'enum/download_format'
require_relative 'enum/report_type'
require_relative 'enum/report_status'
require_relative 'entity/user/user'
require_relative 'entity/user/natural_user'
require_relative 'entity/user/legal_user'
require_relative 'entity/card'
require_relative 'entity/client'
require_relative 'entity/transaction'
require_relative 'entity/transfer'
require_relative 'entity/pre_authorization'
require_relative 'entity/repudiation'
require_relative 'entity/settlement_transfer'
require_relative 'event'
require_relative 'address'
require_relative 'money'
require_relative 'entity/wallet'
require_relative 'e_money'
require_relative 'refund_reason'
require_relative 'document_page_consult'
require_relative 'dispute_reason'

# Module for model classes.
module MangoModel

  # Maps each type to its existing declared field names.
  @fields_by_type = {
    DateTime => %w[date],
    PersonType => %w[person_type],
    KycLevel => %w[kyc_level],
    LegalPersonType => %w[legal_person_type],
    CountryIso => %w[country
                     nationality
                     country_of_residence
                     legal_representative_nationality
                     legal_representative_country_of_residence],
    Address => %w[address
                  headquarters_address
                  legal_representative_address
                  owner_address],
    DepositType => %w[deposit_account_type],
    Money => %w[balance
                credited_e_money
                debited_e_money
                debited_funds
                credited_funds
                fees
                declared_debited_funds
                declared_fees
                disputed_funds
                contested_funds],
    CurrencyIso => %w[currency],
    FundsType => %w[funds_type],
    PlatformType => %w[platform_type],
    TransactionNature => %w[nature],
    TransactionStatus => %w[status],
    TransactionType => %w[type initial_transaction_type],
    PayInPaymentType => %w[payment_type],
    PayInExecutionType => %w[execution_type],
    CardType => %w[card_type],
    SecureMode => %w[secure_mode],
    CultureCode => %w[culture],
    CardValidity => %w[validity],
    PaymentStatus => %w[payment_status],
    DirectDebitType => %w[direct_debit_type],
    MandateScheme => %w[scheme],
    MandateType => %w[mandate_type],
    KycDocRefusedReasonType => %w[refused_reason_type],
    NaturalUserCapacity => %w[capacity],
    EventType => %w[event_type],
    RefundReason => %w[refund_reason],
    RefundReasonType => %w[refund_reason_type],
    DisputeType => %w[dispute_type],
    DisputeReason => %w[dispute_reason],
    DisputeReasonType => %w[dispute_reason_type],
    DownloadFormat => %w[download_format],
    ReportType => %w[report_type]
  }

  class << self

    # Returns an array containing all declared
    # field names of a certain type
    #
    # noinspection RubyResolve
    def fields_of_type(type)
      @fields_by_type[type]
    end

    # Asserts the type of pay-in represented by a hash
    #
    # @param +hash+ [Hash] source hash
    # @return [Class] type of pay-in represented by the hash
    def pay_in_type(hash)
      if hash['PaymentType'] == PayInPaymentType::CARD.to_s\
        && hash['ExecutionType'] == PayInExecutionType::WEB.to_s
        CardWebPayIn
      elsif hash['PaymentType'] == PayInPaymentType::CARD.to_s\
        && hash['ExecutionType'] == PayInExecutionType::DIRECT.to_s
        CardDirectPayIn
      elsif hash['PaymentType'] == PayInPaymentType::PREAUTHORIZED.to_s\
        && hash['ExecutionType'] == PayInExecutionType::DIRECT.to_s
        CardPreAuthorizedPayIn
      elsif hash['PaymentType'] == PayInPaymentType::BANK_WIRE.to_s\
        && hash['ExecutionType'] == PayInExecutionType::DIRECT.to_s
        BankWireDirectPayIn
      elsif hash['PaymentType'] == PayInPaymentType::DIRECT_DEBIT.to_s\
        && hash['ExecutionType'] == PayInExecutionType::WEB.to_s
        DirectDebitWebPayIn
      elsif hash['PaymentType'] == PayInPaymentType::DIRECT_DEBIT.to_s\
        && hash['ExecutionType'] == PayInExecutionType::DIRECT.to_s
        DirectDebitDirectPayIn
      end
    end

    # Asserts the type of bank account represented by a hash.
    #
    # @param +hash+ [Hash] source hash
    # @return [Class] type of bank account represented by the hash
    def bank_account_type(hash)
      case hash['Type']
        when AccountType::IBAN.to_s
          IbanBankAccount
        when AccountType::US.to_s
          UsBankAccount
        when AccountType::CA.to_s
          CaBankAccount
        when AccountType::GB.to_s
          GbBankAccount
        else
          OtherBankAccount
      end
    end

    # Asserts the type of user represented by a hash.
    #
    # @param +hash+ [Hash] source hash
    # @return [Class] type of user represented by the hash
    def user_type(hash)
      case hash['PersonType']
        when PersonType::NATURAL.to_s
          NaturalUser
        else
          LegalUser
      end
    end
  end
end