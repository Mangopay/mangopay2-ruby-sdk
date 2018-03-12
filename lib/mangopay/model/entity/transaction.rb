require_relative '../../common/jsonifier'

module MangoModel

  # Transaction entity
  # A transaction represents an action to relocate money.
  class Transaction < EntityBase
    include MangoPay::Jsonifier

    # [Money] Information about the funds that are being debited
    attr_accessor :debited_funds

    # [Money] Information about the funds that are being credited
    # (+DebitedFunds+ - +Fees+ = +Credited_Funds+)
    attr_accessor :credited_funds

    # [Money] Information about the fees that were taken by the client
    # for this transaction (and transferred to the client's platform's wallet)
    attr_accessor :fees

    # [String] ID of the wallet that was debited from
    attr_accessor :debited_wallet_id

    # [String] ID of the wallet where money will be credited
    attr_accessor :credited_wallet_id

    # [String] ID of the initiating user
    attr_accessor :author_id

    # [String] ID of the user who will be credited (defaults
    # to the owner of the wallet)
    attr_accessor :credited_user_id

    # [TransactionType] Type of the transaction
    attr_accessor :type

    # [TransactionNature] Nature of the transaction
    attr_accessor :nature

    # [TransactionStatus] Status of the transaction
    attr_accessor :status

    # [Integer] Time of execution of the transaction (UNIX timestamp)
    attr_accessor :execution_date

    # [String] Its result code
    attr_accessor :result_code

    # [String] Verbal explanation of the result
    attr_accessor :result_message
  end
end