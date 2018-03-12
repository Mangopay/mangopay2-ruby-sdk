require_relative '../../../common/jsonifier'

module MangoModel

  # Direct-Debit Web Pay-In entity
  # A Pay-In by Direct Debit and via Web is a request to process
  # a payment to a wallet for a dedicated user
  class DirectDebitWebPayIn < PayIn
    include MangoPay::Jsonifier

    # [String] URL to redirect to after payment
    attr_accessor :return_url

    # [DirectDebitType] Type of web direct debit
    attr_accessor :direct_debit_type

    # [CardType] The type of card
    attr_accessor :card_type

    # [SecureMode] The Secure Mode Corresponds to '3D secure' for CB Visa and
    # Mastercard. This field allows manual activation.
    attr_accessor :secure_mode

    # [CultureCode] The language to use for the payment page
    attr_accessor :culture

    # [String] The URL to use for the payment page template
    attr_accessor :template_url

    # [TemplateUrlOptions] An URL to an SSL page to allow customization
    # of the payment page
    attr_accessor :template_url_options

    # [String] URL which to redirect user to in order to proceed
    # with the payment
    attr_accessor :redirect_url
  end
end