require_relative '../../common/jsonifier'

module MangoModel

  # Dispute entity
  # The Dispute object is used when a user requests a chargeback
  # of a transaction to their bank. In turn, their bank withdraws
  # the funds from MangoPay, and MangoPay will then repudiate
  # the required funds from your client credit wallet.
  class Dispute < EntityBase
    include MangoPay::Jsonifier

    # [DisputeType] Its type
    attr_accessor :dispute_type

    # [String] The initial transaction's ID
    attr_accessor :initial_transaction_id

    # [TransactionType] The initial transaction's type
    attr_accessor :initial_transaction_type

    # [String] Its result code
    attr_accessor :result_code

    # {String] Explanation of its result
    attr_accessor :result_message

    # [DisputeReason] Its reason
    attr_accessor :dispute_reason

    # [DisputeStatus] Its status
    attr_accessor :status

    # [String] Explanation of the status
    attr_accessor :status_message

    # [Money] The funds that were disputed
    attr_accessor :disputed_funds

    # [Money] The funds wished to be contested
    attr_accessor :contested_funds

    # [Integer] The deadline by which the dispute must be contested,
    # if necessary (UNIX timestamp)
    attr_accessor :contest_deadline_date

    # [String] ID of the associated repudiation transaction
    attr_accessor :repudiation_id
  end
end