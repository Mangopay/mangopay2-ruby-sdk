require_relative '../../util/enum'

module MangoModel

  # Funds types enumeration
  class FundsType
    extend Enum

    DEFAULT = value 'DEFAULT'

    FEES = value 'FEES'

    CREDIT = value 'CREDIT'
  end
end