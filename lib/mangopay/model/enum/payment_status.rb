require_relative '../../util/enum'

module MangoModel

  # Pre-authorized payment status enumeration
  class PaymentStatus
    extend Enum

    # Payment has been pre-authorized
    WAITING = value 'WAITING'

    # Payment has been canceled manually
    CANCELED = value 'CANCELED'

    # Payment pre-authorization has expired
    EXPIRED = value 'EXPIRED'

    # Pre-authorized payment has been made
    VALIDATED = value 'VALIDATED'
  end
end