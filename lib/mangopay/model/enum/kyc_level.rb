require_relative '../../util/enum'

module MangoModel

  # KYC level enumeration
  class KycLevel
    extend Enum

    LIGHT = value 'LIGHT'

    REGULAR = value 'REGULAR'
  end
end