require_relative '../../../common/jsonifier'

module MangoModel

  # Bank Wire Direct Pay-In entity
  # A Bank Wire Pay-In is a request to process a payment by bank wire
  class BankWireExternalInstructionPayIn < PayIn
    include MangoPay::Jsonifier

    # [String] The declared fees
    attr_accessor :banking_alias_id

    # [String] Wire reference
    attr_accessor :wire_reference

    # [DebitedBankAccount] Information about account that was debited
    attr_accessor :debited_bank_account
  end
end