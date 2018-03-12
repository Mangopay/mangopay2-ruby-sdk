require_relative '../../common/jsonifier'

module MangoModel

  # Refund entity
  class Refund < Transaction
    include MangoPay::Jsonifier

    # [String] The initial transaction's ID
    attr_accessor :initial_transaction_id

    # [TransactionType] The initial transaction's type
    attr_accessor :initial_transaction_type

    # [RefundReason] Info about the reason for refund
    attr_accessor :refund_reason
  end
end