require_relative '../../util/enum'

module MangoModel

  # Transaction status enumeration
  class TransactionStatus
    extend Enum

    CREATED = value 'CREATED'

    SUCCEEDED = value 'SUCCEEDED'

    FAILED = value 'FAILED'
  end
end