require_relative '../common/jsonifier'

module MangoModel

  # Security & validation information
  class SecurityInfo
    include MangoPay::Jsonifier

    # [AVSResult] Result of the AVS verification
    attr_accessor :avs_result

  end
end