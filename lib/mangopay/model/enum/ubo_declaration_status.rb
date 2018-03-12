require_relative '../../util/enum'

module MangoModel

  # UBO Declaration status enumeration
  class UboDeclarationStatus
    extend Enum

    # UBO declaration has been created
    CREATED = value 'CREATED'

    # UBO declaration has been submitted for validation
    VALIDATION_ASKED = value 'VALIDATION_ASKED'

    # UBO declaration has been validated
    VALIDATED = value 'VALIDATED'

    # UBO declaration has been refused
    REFUSED = value 'REFUSED'
  end
end