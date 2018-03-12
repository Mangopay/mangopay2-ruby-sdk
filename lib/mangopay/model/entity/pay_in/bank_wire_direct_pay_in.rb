require_relative '../../../common/jsonifier'

module MangoModel

  # Bank Wire Direct Pay-In entity
  # A Bank Wire Pay-In is a request to process a payment by bank wire
  class BankWireDirectPayIn < PayIn
    include MangoPay::Jsonifier

    # [Money] The declared debited funds
    attr_accessor :declared_debited_funds

    # [Money] The declared fees
    attr_accessor :declared_fees

    # [String] Wire reference
    attr_accessor :wire_reference

    # [BankAccount] The bank account details
    attr_accessor :bank_account
  end
end