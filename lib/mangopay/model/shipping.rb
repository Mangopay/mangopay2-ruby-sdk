require_relative '../common/jsonifier'

module MangoModel

  # Shipping information
  class Shipping
    include MangoPay::Jsonifier

    # [Address] The shipping address
    attr_accessor :address

  end
end