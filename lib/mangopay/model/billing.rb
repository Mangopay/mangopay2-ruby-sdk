require_relative '../common/jsonifier'

module MangoModel

  # Billing information
  class Billing
    include MangoPay::Jsonifier

    # [Address] The billing address
    attr_accessor :address

  end
end