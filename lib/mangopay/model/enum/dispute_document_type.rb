require_relative '../../util/enum'

module MangoModel

  # Dispute Document types enumeration
  class DisputeDocumentType
    extend Enum

    DELIVERY_PROOF = value 'DELIVERY_PROOF'

    INVOICE = value 'INVOICE'

    REFUND_PROOF = value 'REFUND_PROOF'

    USER_CORRESPONDANCE = value 'USER_CORRESPONDANCE'

    USER_ACCEPTANCE_PROOF = value 'USER_ACCEPTANCE_PROOF'

    PRODUCT_REPLACEMENT_PROOF = value 'PRODUCT_REPLACEMENT_PROOF'

    OTHER = value 'OTHER'
  end
end