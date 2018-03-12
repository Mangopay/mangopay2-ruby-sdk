require_relative '../../util/enum'

module MangoModel

  # Direct Debit types enumeration
  class DirectDebitType
    extend Enum

    SOFORT = value 'SOFORT'

    GIROPAY = value 'GIROPAY'
  end
end