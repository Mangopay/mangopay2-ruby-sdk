require_relative '../../util/enum'

module MangoModel
  # Banking alias type enum
  class BankingAliasType
    extend Enum

    NOTSPECIFIED = value 'NotSpecified'

    IBAN = value 'IBAN'
  end
end
