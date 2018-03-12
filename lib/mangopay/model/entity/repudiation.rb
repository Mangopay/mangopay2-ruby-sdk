require_relative '../../common/jsonifier'

module MangoModel

  # Repudiation entity
  # A Repudiation is created when a user has requested a chargeback
  # for a pay-in and the bank has withdrawn the funds from MangoPay
  # automatically. A repudiation is always linked to a dispute.
  class Repudiation < Transaction
    include MangoPay::Jsonifier

    # [String] ID of the initial transaction
    attr_accessor :initial_transaction_id

    # [TransactionType] Type of the initial transaction
    attr_accessor :initial_transaction_type
  end
end