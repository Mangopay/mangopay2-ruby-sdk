require_relative '../../common/jsonifier'

module MangoModel

  # Dispute Document entity
  # A Dispute Document must be created in order to upload pages
  # of a document pertaining to a certain dispute.
  class DisputeDocument < EntityBase
    include MangoPay::Jsonifier

    # [String] ID of the corresponding dispute
    attr_accessor :dispute_id

    # [DocumentStatus] Its status
    attr_accessor :status

    # [DisputeDocumentType] Its type
    attr_accessor :type

    # [DisputeDocRefusedReasonType] Type of its refusal reason
    attr_accessor :refused_reason_type

    # [String] Explanation of its refusal
    attr_accessor :refused_reason_message

    # [Integer] Time when the document was processed (UNIX timestamp)
    attr_accessor :processed_date
  end
end