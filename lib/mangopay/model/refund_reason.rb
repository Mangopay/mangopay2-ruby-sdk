require_relative '../common/jsonifier'

module MangoModel

  # Reason for a refund
  class RefundReason
    include MangoPay::Jsonifier

    # [RefundReasonType] Type of reason for refusal
    attr_accessor :refused_reason_type

    # [String] Message accompanying a refusal
    attr_accessor :refused_reason_message
  end
end