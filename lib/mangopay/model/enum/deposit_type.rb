require_relative '../../util/enum'

module MangoModel

  # Bank account deposit type enumeration
  class DepositType
    extend Enum

    # Checking account deposit type
    CHECKING = value 'CHECKING'

    # Savings account deposit type
    SAVINGS = value 'SAVINGS'
  end
end