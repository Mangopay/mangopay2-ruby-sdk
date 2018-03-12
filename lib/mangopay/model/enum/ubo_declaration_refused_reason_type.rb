require_relative '../../util/enum'

module MangoModel

  # UBO Declaration refusal reasons enumeration
  class UboDeclarationRefusedReasonType
    extend Enum

    # At least one natural user is missing from the declaration
    MISSING_UBO = value 'MISSING_UBO'

    # At least one of the natural users should not be declared as UBO
    INVALID_DECLARED_UBO = value 'INVALID_DECLARED_UBO'

    # At least one of the natural users declared as UBOs has been
    # created with wrong details (i.e. date of birth, country of residence)
    INVALID_UBO_DETAILS = value 'INVALID_UBO_DETAILS'
  end
end