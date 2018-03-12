require_relative '../../util/enum'

module MangoModel

  # Dispute Document refusal reason types enumeration
  class DisputeDocRefusedReasonType
    extend Enum

    DOCUMENT_UNREADABLE = value 'DOCUMENT_UNREADABLE'

    DOCUMENT_NOT_ACCEPTED = value 'DOCUMENT_NOT_ACCEPTED'

    DOCUMENT_HAS_EXPIRED = value 'DOCUMENT_HAS_EXPIRED'

    DOCUMENT_INCOMPLETE = value 'DOCUMENT_INCOMPLETE'

    DOCUMENT_MISSING = value 'DOCUMENT_MISSING'

    SPECIFIC_CASE = value 'SPECIFIC_CASE'

    DOCUMENT_FALSIFIED = value 'DOCUMENT_FALSIFIED'

    OTHER = value 'OTHER'
  end
end