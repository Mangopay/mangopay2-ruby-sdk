require_relative '../../util/enum'

module MangoModel

  # Pre-Authorization status enumeration
  class PreAuthorizationStatus
    extend Enum

    # Pre-Authorization has been created
    CREATED = value 'CREATED'

    # Pre-Authorization has succeeded
    SUCCEEDED = value 'SUCCEEDED'

    # Pre-Authorization has failed
    FAILED = value 'FAILED'
  end
end