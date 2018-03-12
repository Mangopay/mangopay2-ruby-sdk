require_relative '../../util/enum'

module MangoModel

  # Transaction nature enumeration
  class TransactionNature
    extend Enum

    REGULAR = value 'REGULAR'

    REPUDIATION = value 'REPUDIATION'

    REFUND = value 'REFUND'

    SETTLEMENT = value 'SETTLEMENT'
  end
end