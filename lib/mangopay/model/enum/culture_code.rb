require_relative '../../util/enum'

module MangoModel

  # Culture codes enumeration
  # Represents ISO code of the language to use for the payment page.
  class CultureCode
    extend Enum

    DE = value 'DE'

    EN = value 'EN'

    DA = value 'DA'

    ES = value 'ES'

    ET = value 'ET'

    FI = value 'FI'

    FR = value 'FR'

    EL = value 'EL'

    HU = value 'HU'

    IT = value 'IT'

    NL = value 'NL'

    NO = value 'NO'

    PL = value 'PL'

    PT = value 'PT'

    SK = value 'SK'

    SV = value 'SV'

    CS = value 'CS'
  end
end