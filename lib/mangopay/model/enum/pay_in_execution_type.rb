require_relative '../../util/enum'

module MangoModel

  # Pay In execution types enumeration
  class PayInExecutionType
    extend Enum

    # Web execution type
    WEB = value 'WEB'

    # Direct execution type
    DIRECT = value 'DIRECT'

    # External instruction execution type
    EXTERNAL_INSTRUCTION = value 'EXTERNAL_INSTRUCTION'
  end
end