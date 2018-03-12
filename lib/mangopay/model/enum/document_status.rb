require_relative '../../util/enum'

module MangoModel

  # Document status enumeration
  class DocumentStatus
    extend Enum

    # Document has been created
    CREATED = value 'CREATED'

    # Document validation has been requested
    VALIDATION_ASKED = value 'VALIDATION_ASKED'

    # Document has been validated
    VALIDATED = value 'VALIDATED'

    # Document has been refused
    REFUSED = value 'REFUSED'
  end
end