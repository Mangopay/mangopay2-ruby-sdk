require_relative '../../util/enum'

module MangoModel

  # Legal person types enumeration
  class LegalPersonType
    extend Enum

    BUSINESS = value 'BUSINESS'

    ORGANIZATION = value 'ORGANIZATION'

    SOLETRADER = value 'SOLETRADER'
  end
end