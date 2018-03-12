require_relative '../../common/jsonifier'

module MangoModel

  # Card entity
  class Card < EntityBase
    include MangoPay::Jsonifier

    # [Integer] Its expiry date (MM/YY format)
    attr_accessor :expiration_date

    # [String] A partially obfuscated version of its credit card number
    attr_accessor :alias

    # [String] Its provider
    attr_accessor :card_provider

    # [CardType] Its type
    attr_accessor :card_type

    # [String] Country of its address
    attr_accessor :country

    # [String] Its product type
    attr_accessor :product

    # [String] Its bank code
    attr_accessor :bank_code

    # [true/false] Whether or not it is active
    attr_accessor :active

    # [CurrencyIso] Its currency
    attr_accessor :currency

    # [CardValidity] Whether or not it is valid
    attr_accessor :validity

    # [String] A unique representation of a 16-digit card number
    attr_accessor :fingerprint

    # [String] ID of its owner
    attr_accessor :user_id
  end
end