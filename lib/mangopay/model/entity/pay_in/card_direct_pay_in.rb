require_relative 'pay_in'
require_relative '../../../common/jsonifier'

module MangoModel

  # Card Direct Pay In entity
  # The Card Direct Pay In object lets you pay with a registered card.
  class CardDirectPayIn < PayIn
    include MangoPay::Jsonifier

    # [String] URL which users are automatically redirected to
    # after 3D secure validation (if activated)
    attr_accessor :secure_mode_return_url

    # [CardType] ID of the card
    attr_accessor :card_id

    # [SecureMode] The Secure Mode Corresponds to '3D secure' for CB Visa and
    # Mastercard. This field allows manual activation.
    attr_accessor :secure_mode

    # [String] Custom description to appear on the user's bank statement.
    # (max 100 alphanumeric/spaces)
    attr_accessor :statement_descriptor

    # [true/false] Whether the Secure Mode was used
    attr_accessor :secure_mode_needed

    # [String] The URL where to redirect users to proceed to
    # 3D secure validation
    attr_accessor :secure_mode_redirect_url

    # [Billing] Billing information
    attr_accessor :billing

    # [SecurityInfo] Security & Validation information
    attr_accessor :security_info

    # [CultureCode] The language to use for the payment page
    attr_accessor :culture

    # [String] The ip address
    attr_accessor :ip_address

    # [Shipping] Shipping information
    attr_accessor :shipping
  end
end