require_relative '../../util/enum'

module MangoModel

  # Secure modes enumeration
  class SecureMode
    extend Enum

    # Automatic activation of the Secure Mode, when transaction
    # is higher than 50 EUR or when MangoPay detects there is a higher risk
    DEFAULT = value 'DEFAULT'

    # Force activation of the Secure Mode for a transaction
    FORCE = value 'FORCE'

    NO_CHOICE = value 'NO_CHOICE'
  end
end