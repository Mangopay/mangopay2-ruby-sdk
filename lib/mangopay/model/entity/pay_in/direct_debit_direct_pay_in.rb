require_relative '../../../common/jsonifier'

module MangoModel

  # Direct-Debit Direct Pay-In entity
  # A Pay-In by Direct Debit with a Mandate is a request to process a
  # payment to a wallet for a dedicated user
  class DirectDebitDirectPayIn < PayIn
    include MangoPay::Jsonifier

    # [String] ID of the mandate
    attr_accessor :mandate_id

    # [Integer] Date when the user will be charged (UNIX timestamp)
    # Note: For Direct-Debit payments, it will take one more day
    # before the payment becomes successful.
    attr_accessor :charge_date

    # [String] A custom description to appear on the user's bank statement.
    # (max 100 alphanumeric/spaces, available only for SEPA payments)
    attr_accessor :statement_descriptor

    # [CultureCode] The language to use for the payment page
    attr_accessor :culture
  end
end