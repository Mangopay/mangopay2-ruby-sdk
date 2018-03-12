require_relative '../../util/enum'

module MangoModel

  # Transaction types enumeration
  class TransactionType
    extend Enum

    PAYIN = value 'PAYIN'

    PAYOUT = value 'PAYOUT'

    TRANSFER = value 'TRANSFER'
  end
end