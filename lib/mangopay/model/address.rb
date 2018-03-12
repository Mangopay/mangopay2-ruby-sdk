require_relative '../common/jsonifier'

module MangoModel

  # Represents an address.
  class Address
    include MangoPay::Jsonifier

    # [String] First line of its details
    attr_accessor :address_line1

    # [String] Second line of its details
    attr_accessor :address_line2

    # [String] Its city
    attr_accessor :city

    # [String] Its region
    attr_accessor :region

    # [String] Its postal code
    attr_accessor :postal_code

    # [CountryIso] Its country
    attr_accessor :country
  end
end