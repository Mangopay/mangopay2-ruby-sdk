require_relative '../../util/enum'

module MangoModel

  # Result of an AVS verification
  class AvsResult
    extend Enum

    FULL_MATCH = value 'FULL_MATCH'

    ADDRESS_MATCH_ONLY = value 'ADDRESS_MATCH_ONLY'

    POSTAL_CODE_MATCH_ONLY = value 'POSTAL_CODE_MATCH_ONLY'

    NO_MATCH = value 'NO_MATCH'

    NO_CHECK = value 'NO_CHECK'
  end
end