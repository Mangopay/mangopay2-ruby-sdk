require_relative '../../../lib/mangopay/common/jsonifier'

module MangoModel

  # Represents a birthplace.
  class Birthplace
    include MangoPay::Jsonifier

    # [String] city
    attr_accessor :city

    # [CountryIso] Its country
    attr_accessor :country
  end
end