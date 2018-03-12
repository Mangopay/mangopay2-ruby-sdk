require_relative '../../util/enum'

module MangoModel

  # Enumeration of validation status of users declared as UBO
  class DeclaredUboStatus
    extend Enum

    # Declaration of this user has been created
    CREATED = value 'CREATED'

    # Declaration of this user has been validated
    VALIDATED = value 'VALIDATED'

    # Declaration of this user has been refused
    REFUSED = value 'REFUSED'
  end
end