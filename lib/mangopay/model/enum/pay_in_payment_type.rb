require_relative '../../util/enum'

module MangoModel

  # Pay In payment types enumeration
  class PayInPaymentType
    extend Enum

    # Payment by card
    CARD = value 'CARD'

    # Direct debit payment
    DIRECT_DEBIT = value 'DIRECT_DEBIT'

    # Preauthorized payment
    PREAUTHORIZED = value 'PREAUTHORIZED'

    # Payment through bank wire
    BANK_WIRE = value 'BANK_WIRE'

    # Payment through paypal
    PAYPAL = value "PAYPAL"

    # Payment through apple pay
    APPLEPAY = value "APPLEPAY"
  end
end