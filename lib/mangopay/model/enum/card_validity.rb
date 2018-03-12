require_relative '../../util/enum'

module MangoModel

  # Card validity status enumeration
  class CardValidity
    extend Enum

    # Before any payment processing is attempted, a card's
    # validity is not determined
    UNKNOWN = value 'UNKNOWN'

    # Card is valid
    VALID = value 'VALID'

    # Card is not valid
    INVALID = value 'INVALID'
  end
end