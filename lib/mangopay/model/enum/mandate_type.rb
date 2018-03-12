require_relative '../../util/enum'

module MangoModel

  # Mandate types enumeration
  class MandateType
    extend Enum

    DIRECT_DEBIT = value 'DIRECT_DEBIT'
  end
end