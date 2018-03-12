require_relative '../../common/jsonifier'

module MangoModel

  # Card Registration entity
  class CardRegistration < EntityBase
    include MangoPay::Jsonifier

    # [String] Its owner's ID
    attr_accessor :user_id

    # [CurrencyIso] Its currency
    attr_accessor :currency

    # [String] Its access key (a special key needed for registering a card)
    attr_accessor :access_key

    # [String] A specific value to pass to the card registration URL
    attr_accessor :preregistration_data

    # [String] The URL to submit the card details form to
    attr_accessor :card_registration_url

    # [String] Having registered a card, this confirmation hash needs to be
    # updated to the card item
    attr_accessor :registration_data

    # [CardType] The type of card
    attr_accessor :card_type

    # [String] The card's ID
    attr_accessor :card_id

    # [String] The result code
    attr_accessor :result_code

    # [String] Explanation of the result
    attr_accessor :result_message

    # [CardStatus] Status of the registration
    attr_accessor :status
  end
end