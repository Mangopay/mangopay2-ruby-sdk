require_relative '../../util/enum'

module MangoModel

  # Dispute types enumeration
  class DisputeType
    extend Enum

    CONTESTABLE = value 'CONTESTABLE'

    NOT_CONTESTABLE = value 'NOT_CONTESTABLE'

    RETRIEVAL = value 'RETRIEVAL'
  end
end