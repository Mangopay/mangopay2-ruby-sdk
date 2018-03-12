require_relative '../common/jsonifier'

module MangoModel

  # The Pay-In Web Extended View is an object which provides
  # more details about the card used to process a Web Pay-In
  class PayInWebExtendedView
    include MangoPay::Jsonifier

    # [String] The item's ID
    attr_accessor :id

    # [PayInPaymentType] The type of pay-in
    attr_accessor :payment_type

    # [Integer] Time when the transaction happened (UNIX timestamp)
    attr_accessor :execution_date

    # [String] The expiry date of the card (MMYY format)
    attr_accessor :expiration_date

    # [String] A partially obfuscated version of the credit card number
    attr_accessor :alias

    # [CardType] The type of card
    attr_accessor :card_type

    # [CountryIso] Country of the address
    attr_accessor :country
  end
end