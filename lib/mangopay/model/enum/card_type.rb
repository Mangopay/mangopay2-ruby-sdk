require_relative '../../util/enum'

module MangoModel

  # Card types enumeration
  class CardType
    extend Enum

    # Visa MasterCard
    CB_VISA_MASTERCARD = value 'CB_VISA_MASTERCARD'

    # Diners card
    DINERS = value 'DINERS'

    # MasterPass card
    MASTERPASS = value 'MASTERPAS'

    # Maestro card
    MAESTRO = value 'MAESTRO'

    # P24 card
    P24 = value 'P24'

    # Ideal card
    IDEAL = value 'IDEAL'

    # BCMC card
    BCMC = value 'BCMC'

    # PayLib card
    PAYLIB = value 'PAYLIB'
  end
end