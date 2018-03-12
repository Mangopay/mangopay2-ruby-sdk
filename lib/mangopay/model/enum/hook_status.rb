require_relative '../../util/enum'

module MangoModel

  # Hook status enumeration
  class HookStatus
    extend Enum

    DISABLED = value 'DISABLED'

    ENABLED = value 'ENABLED'
  end
end