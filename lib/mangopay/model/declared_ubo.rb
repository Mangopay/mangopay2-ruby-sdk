require_relative '../common/jsonifier'

module MangoModel

  # Object that represents validation status of a user declared as UBO
  class DeclaredUbo
    include MangoPay::Jsonifier

    # [String] ID of the natural user declared as UBO
    attr_accessor :user_id

    # [DeclaredUboStatus] Validation status of the user declared as UBO
    attr_accessor :status

    # [DeclaredUboRefusedReasonType] Reason why the UBO is not validly declared
    attr_accessor :refused_reason_type

    # [String] Explanation of why the UBO declaration has been refused
    attr_accessor :refused_reason_message
  end
end