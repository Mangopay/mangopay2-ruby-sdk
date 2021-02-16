require_relative '../common/jsonifier'

module MangoModel

  # Shipping information
  class Shipping
    include MangoPay::Jsonifier

    # [String] FirstName
    attr_accessor :first_name

    # [String] FirstName
    attr_accessor :last_name

    # [Address] The shipping address
    attr_accessor :address

  end
end