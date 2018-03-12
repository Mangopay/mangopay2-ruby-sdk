require_relative '../../util/enum'

module MangoModel

  # Card registration status enumeration
  class CardStatus
    extend Enum

    CREATED = value 'CREATED'

    VALIDATED = value 'VALIDATED'

    ERROR = value 'ERROR'
  end
end