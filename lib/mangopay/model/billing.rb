require_relative '../common/jsonifier'

module MangoModel

  # Billing information
  class Billing
    include MangoPay::Jsonifier

    # [String] FirstName
    attr_accessor :first_name

    # [String] FirstName
    attr_accessor :last_name

    # [Address] The billing address
    attr_accessor :address

  end
end