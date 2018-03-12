require_relative '../../util/enum'

module MangoModel

  # Enumeration of refusal reasons for a declared UBO
  class DeclaredUboRefusedReasonType
    extend Enum

    # The user should not be declared as UBO
    INVALID_DECLARED_UBO = value 'INVALID_DECLARED_UBO'

    # The user declared as UBO has been created with
    # wrong details (i.e. date of birth, country of residence)
    INVALID_UBO_DETAILS = value 'INVALID_UBO_DETAILS'
  end
end