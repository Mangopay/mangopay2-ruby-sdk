require_relative '../common/jsonifier'

module MangoModel

  # Reason of a dispute
  class DisputeReason
    include MangoPay::Jsonifier

    # [DisputeReasonType] Type of reason for the dispute
    attr_accessor :dispute_reason_type

    # [String] Explanation of the dispute reason
    attr_accessor :dispute_reason_message
  end
end