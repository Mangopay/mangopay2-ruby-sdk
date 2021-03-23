require_relative 'pay_in'
require_relative '../../../common/jsonifier'

module MangoModel

  # Card Web Pay-In entity
  # A Pay In by card and via web interface is a request
  # to process a payment to a wallet for a dedicated user.
  class CardWebPayIn < PayIn
    include MangoPay::Jsonifier

    # [String] URL to redirect to after payment
    attr_accessor :return_url

    # [CardType] The type of card
    attr_accessor :card_type

    # [SecureMode] The Secure Mode Corresponds to '3D secure' for CB Visa and
    # Mastercard. This field allows manual activation.
    attr_accessor :secure_mode

    # [String] The URL to use for the payment page template
    attr_accessor :template_url

    # [TemplateUrlOptions] An URL to an SSL page to allow customization
    # of the payment page
    attr_accessor :template_url_options

    # [String] Custom description to appear on the user's bank statement.
    # (max 100 alphanumeric/spaces)
    attr_accessor :statement_descriptor

    # [String] The URL to redirect the user to for them to proceed
    # with the payment
    attr_accessor :redirect_url

    # [Shipping] Shipping information
    attr_accessor :shipping

    # [String] Requested3DSVersion
    attr_accessor :requested_3ds_version

    # [String] Applied3DSVersion
    attr_accessor :applied_3ds_version
  end
end