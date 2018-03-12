require_relative '../../util/enum'

module MangoModel

  # Mandate schemes enumeration
  class MandateScheme
    extend Enum

    SEPA = value 'SEPA'

    BACS = value 'BACS'
  end
end