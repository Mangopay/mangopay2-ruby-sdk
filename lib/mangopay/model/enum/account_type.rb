require_relative '../../util/enum'

module MangoModel

  # Bank account types enumeration
  class AccountType
    extend Enum

    # IBAN bank account
    IBAN = value 'IBAN'

    # US format bank account
    US = value 'US'

    # CA format bank account
    CA = value 'CA'

    # GB format bank account
    GB = value 'GB'

    # Unspecified bank account format
    OTHER = value 'OTHER'
  end
end