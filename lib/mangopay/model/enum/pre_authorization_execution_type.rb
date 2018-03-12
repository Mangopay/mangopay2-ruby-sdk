require_relative '../../util/enum'

module MangoModel

  # Pre-Authorization execution types enumeration
  class PreAuthorizationExecutionType
    extend Enum

    DIRECT = value 'DIRECT'
  end
end