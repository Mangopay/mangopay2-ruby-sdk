require_relative '../../common/jsonifier'

module MangoModel

  # KYC Document entity
  # The KYC Document object is a request to validate a required document.
  class KycDocument < EntityBase
    include MangoPay::Jsonifier

    # [KycDocumentType] Its type
    attr_accessor :type

    # [String] ID of its owner
    attr_accessor :user_id

    # [DocumentStatus] Its processing status
    attr_accessor :status

    # [String] The message accompanying a refusal
    attr_accessor :refused_reason_message

    # [KycDocRefusedReasonType] Reason of refusal
    attr_accessor :refused_reason_type

    # [Integer] Time when the document was processed (UNIX timestamp)
    attr_accessor :processed_date
  end
end