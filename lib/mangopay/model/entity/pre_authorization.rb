require_relative '../../common/jsonifier'

module MangoModel

  # Pre-Authorization entity
  # The Pre-Authorization object ensures the solvency of a
  # registered card for 7 days.
  #
  # The overall process is as follows:
  # Register a card (CardRegistration)
  # Create a PreAuthorization with the CardId. This allows you to charge an amount on a card
  # Charge the card through the PreAuthorized PayIn object (Payins/preauthorized/direct)
  #
  # How does PreAuthorization work?
  # Once the PreAuthorization object is created the Status is "CREATED" until 3D secure validation.
  # If the authorization is successful the status is "SUCCEEDED" if it failed the status is "FAILED".
  # Once Status = "SUCCEEDED" and PaymentStatus = "WAITING" you can charge the card.
  # The Pay-In amount has to be less than or equal to the amount authorized.
  class PreAuthorization < EntityBase
    include MangoPay::Jsonifier

    # [String] Its authoring user's ID
    attr_accessor :author_id

    # [Money] Information about the funds being debited
    attr_accessor :debited_funds

    # [PreAuthorizationStatus] Its status
    attr_accessor :status

    # [PaymentStatus] Its pre-authorized payment status
    # Can be set to +CANCELED+ if needed
    attr_accessor :payment_status

    # [String] Its result code
    attr_accessor :result_code

    # [String] Explanation of its result
    attr_accessor :result_message

    # [PreAuthorizationExecutionType] How the pre-authorization was executed
    attr_accessor :execution_type

    # [SecureMode] The Secure Mode Corresponds to '3D secure' for CB Visa and
    # Mastercard. This field allows manual activation.
    attr_accessor :secure_mode

    # [String] ID of the pre-authorized card
    attr_accessor :card_id

    # [true/false] True if the Secure Mode was used
    attr_accessor :secure_mode_needed

    # [String] URL which to redirect users to in order to proceed
    # to 3D secure validation
    attr_accessor :secure_mode_redirect_url

    # [String] URL which users are automatically redirected to
    # after 3D secure validation
    attr_accessor :secure_mode_return_url

    # [Integer] Date by when the payment should be processed (UNIX timestamp)
    attr_accessor :expiration_date

    # [String] ID of the associated Pay-in
    attr_accessor :pay_in_id

    # [Billing] Billing information
    attr_accessor :billing

    # [SecurityInfo] Security & validation information
    attr_accessor :security_info

    # [true/false] True if the Multi Capture was used
    attr_accessor :multi_capture

    # [Money] Information about the remaining funds
    attr_accessor :remaining_funds

    # [String] IpAddress
    attr_accessor :ip_address

    # [Shipping] Shipping information
    attr_accessor :shipping

    # [BrowserInfo] Browser Info
    attr_accessor :browser_info
  end
end