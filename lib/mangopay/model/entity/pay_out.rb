require_relative 'transaction'
require_relative '../../common/jsonifier'

module MangoModel

  # Pay-Out entity
  # A Pay-Out bank-wire is a request to withdraw money from a wallet
  # to a bank account.
  class PayOut < Transaction
    include MangoPay::Jsonifier

    # [String] ID of the bank account
    attr_accessor :bank_account_id

    # [String] A custom reference to be present on the user's bank
    # statement along with environment's Client name (max 12 chars)
    attr_accessor :bank_wire_ref

    # [PayOutPaymentType] Its type
    attr_accessor :payment_type
  end
end