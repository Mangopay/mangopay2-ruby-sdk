require_relative '../../util/enum'

module MangoModel

  # Pay-Out payment types enumeration
  class PayOutPaymentType
    extend Enum

    BANK_WIRE = value 'BANK_WIRE'
  end
end