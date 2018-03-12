require_relative '../../util/enum'

module MangoModel

  # Hook validity enumeration
  class HookValidity
    extend Enum

    UNKNOWN = value 'UNKNOWN'

    VALID = value 'VALID'

    INVALID = value 'INVALID'
  end
end