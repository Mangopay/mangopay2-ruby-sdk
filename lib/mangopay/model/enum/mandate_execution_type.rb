require_relative '../../util/enum'

module MangoModel

  # Mandate creation execution types enumeration
  class MandateExecutionType
    extend Enum

    WEB = value 'WEB'
  end
end