require_relative '../../util/enum'

module MangoModel

  # ISO 4217 format currency codes enumeration
  class CurrencyIso
    extend Enum

    # No currency
    XXX = value 'XXX'

    # United Arab Emirates dirham
    AED = value 'AED'

    # Afghan afghani
    AFN = value 'AFN'

    # Albanian lek
    ALL = value 'ALL'

    # Armenian dram
    AMD = value 'AMD'

    # Netherlands Antillean guilder
    ANG = value 'ANG'

    # Angolan kvanza
    AOA = value 'AOA'

    # Argentine peso
    ARS = value 'ARS'

    # Australian dollar
    AUD = value 'AUD'

    # Aruban florin
    AWG = value 'AWG'

    # Azerbaijani manat
    AZN = value 'AZN'

    # Bosnia and Herzegovina convertible mark
    BAM = value 'BAM'

    # Barbados dollar
    BBD = value 'BBD'

    # Bangladeshi taka
    BDT = value 'BDT'

    # Bulgarian lev
    BGN = value 'BGN'

    # Bahraini dinar
    BHD = value 'BHD'

    # Burundian franc
    BIF = value 'BIF'

    # Bermudian dollar
    BMD = value 'BMD'

    # Brunei dollar
    BND = value 'BND'

    # Boliviano
    BOB = value 'BOB'

    # Bolivian Mvdol (funds code)
    BOV = value 'BOV'

    # Brazilian real
    BRL = value 'BRL'

    # Bahamian dollar
    BSD = value 'BSD'

    # Bhutanese ngultrum
    BTN = value 'BTN'

    # Botswana pula
    BWP = value 'BWP'

    # Belarusian ruble
    BYR = value 'BYR'

    # Belize dollar
    BZD = value 'BZD'

    # Canadian dollar
    CAD = value 'CAD'

    # Congolese franc
    CDF = value 'CDF'

    # WIR Euro (complementary currency)
    CHE = value 'CHE'

    # Swiss franc
    CHF = value 'CHF'

    # WIR Franc (complementary currency)
    CHW = value 'CHW'

    # Unidad de Fomento (funds code)
    CLF = value 'CLF'

    # Chilean peso
    CLP = value 'CLP'

    # Chinese yuan
    CNY = value 'CNY'

    # Colombian peso
    COP = value 'COP'

    # Unidad de Valor Real (UVR) (funds code)[7]
    COU = value 'COU'

    # Costa Rican colon
    CRC = value 'CRC'

    # Cuban convertible peso
    CUC = value 'CUC'

    # Cuban peso
    CUP = value 'CUP'

    # Cape Verde escudo
    CVE = value 'CVE'

    # Czech koruna
    CZK = value 'CZK'

    # Djiboutian franc
    DJF = value 'DJF'

    # Danish krone
    DKK = value 'DKK'

    # Dominican peso
    DOP = value 'DOP'

    # Algerian dinar
    DZD = value 'DZD'

    # Egyptian pound
    EGP = value 'EGP'

    # Eritrean nakfa
    ERN = value 'ERN'

    # Ethiopian birr
    ETB = value 'ETB'

    # Euro
    EUR = value 'EUR'

    # Fiji dollar
    FJD = value 'FJD'

    # Falkland Islands pound
    FKP = value 'FKP'

    # Pound sterling
    GBP = value 'GBP'

    # Georgian lari
    GEL = value 'GEL'

    # Ghanaian cedi
    GHS = value 'GHS'

    # Gibraltar pound
    GIP = value 'GIP'

    # Gambian dalasi
    GMD = value 'GMD'

    # Guinean franc
    GNF = value 'GNF'

    # Guatemalan quetzal
    GTQ = value 'GTQ'

    # Guyanese dollar
    GYD = value 'GYD'

    # Hong Kong dollar
    HKD = value 'HKD'

    # Honduran lempira
    HNL = value 'HNL'

    # Croatian kuna
    HRK = value 'HRK'

    # Haitian gourde
    HTG = value 'HTG'

    # Hungarian forint
    HUF = value 'HUF'

    # Indonesian rupiah
    IDR = value 'IDR'

    # Israeli new shekel
    ILS = value 'ILS'

    # Indian rupee
    INR = value 'INR'

    # Iraqi dinar
    IQD = value 'IQD'

    # Iranian rial
    IRR = value 'IRR'

    # Icelandic króna
    ISK = value 'ISK'

    # Jamaican dollar
    JMD = value 'JMD'

    # Jordanian dinar
    JOD = value 'JOD'

    # Japanese yen
    JPY = value 'JPY'

    # Kenyan shilling
    KES = value 'KES'

    # Kyrgyzstani som
    KGS = value 'KGS'

    # Cambodian riel
    KHR = value 'KHR'

    # Comoro franc
    KMF = value 'KMF'

    # North Korean won
    KPW = value 'KPW'

    # South Korean won
    KRW = value 'KRW'

    # Kuwaiti dinar
    KWD = value 'KWD'

    # Cayman Islands dollar
    KYD = value 'KYD'

    # Kazakhstani tenge
    KZT = value 'KZT'

    # Lao kip
    LAK = value 'LAK'

    # Lebanese pound
    LBP = value 'LBP'

    # Sri Lankan rupee
    LKR = value 'LKR'

    # Liberian dollar
    LRD = value 'LRD'

    # Lesotho loti
    LSL = value 'LSL'

    # Lithuanian litas
    LTL = value 'LTL'

    # Libyan dinar
    LYD = value 'LYD'

    # Moroccan dirham
    MAD = value 'MAD'

    # Moldovan leu
    MDL = value 'MDL'

    # Malagasy ariary
    MGA = value 'MGA'

    # Macedonian denar
    MKD = value 'MKD'

    # Myanmar kyat
    MMK = value 'MMK'

    # Mongolian tugrik
    MNT = value 'MNT'

    # Macanese pataca
    MOP = value 'MOP'

    # Mauritanian ouguiya
    MRO = value 'MRO'

    # Mauritian rupee
    MUR = value 'MUR'

    # Maldivian rufiyaa
    MVR = value 'MVR'

    # Malawian kwacha
    MWK = value 'MWK'

    # Mexican peso
    MXN = value 'MXN'

    # Mexican Unidad de Inversion(UDI) (funds code)
    MXV = value 'MXV'

    # Malaysian ringgit
    MYR = value 'MYR'

    # Mozambican metical
    MZN = value 'MZN'

    # Namibian dollar
    NAD = value 'NAD'

    # Nigerian naira
    NGN = value 'NGN'

    # Nicaraguan córdoba
    NIO = value 'NIO'

    # Norwegian krone
    NOK = value 'NOK'

    # Nepalese rupee
    NPR = value 'NPR'

    # New Zealand dollar
    NZD = value 'NZD'

    # Omani rial
    OMR = value 'OMR'

    # Panamanian balboa
    PAB = value 'PAB'

    # Peruvian nuevo sol
    PEN = value 'PEN'

    # Papua New Guinean kina
    PGK = value 'PGK'

    # Philippine peso
    PHP = value 'PHP'

    # Pakistani rupee
    PKR = value 'PKR'

    # Polish złoty
    PLN = value 'PLN'

    # Paraguayan guaraní
    PYG = value 'PYG'

    # Qatari riyal
    QAR = value 'QAR'

    # Romanian new leu
    RON = value 'RON'

    # Serbian dinar
    RSD = value 'RSD'

    # Russian ruble
    RUB = value 'RUB'

    # Rwandan franc
    RWF = value 'RWF'

    # Saudi riyal
    SAR = value 'SAR'

    # Solomon Islands dollar
    SBD = value 'SBD'

    # Seychelles rupee
    SCR = value 'SCR'

    # Sudanese pound
    SDG = value 'SDG'

    # Swedish krona/kronor
    SEK = value 'SEK'

    # Singapore dollar
    SGD = value 'SGD'

    # Saint Helena pound
    SHP = value 'SHP'

    # Sierra Leonean leone
    SLL = value 'SLL'

    # Somali shilling
    SOS = value 'SOS'

    # Surinamese dollar
    SRD = value 'SRD'

    # South Sudanese pound
    SSP = value 'SSP'

    # Sao Tomé and Príncipe dobra
    STD = value 'STD'

    # Syrian pound
    SYP = value 'SYP'

    # Swazi lilangeni
    SZL = value 'SZL'

    # Thai baht
    THB = value 'THB'

    # Tajikistani somoni
    TJS = value 'TJS'

    # Turkmenistani manat
    TMT = value 'TMT'

    # Tunisian dinar
    TND = value 'TND'

    # Tongan pa'anga
    TOP = value 'TOP'

    # Turkish lira
    TRY = value 'TRY'

    # Trinidad and Tobago dollar
    TTD = value 'TTD'

    # New Taiwan dollar
    TWD = value 'TWD'

    # Tanzanian shilling
    TZS = value 'TZS'

    # Ukrainian hryvnia
    UAH = value 'UAH'

    # Ugandan shilling
    UGX = value 'UGX'

    # United States dollar
    USD = value 'USD'

    # United States dollar (next day) (funds code)
    USN = value 'USN'

    # United States dollar (same day) (funds code)[10]
    USS = value 'USS'

    # Uruguay Peso en Unidades Indexadas (URUIURUI) (funds code)
    UYI = value 'UYI'

    # Uruguayan peso
    UYU = value 'UYU'

    # Uzbekistan som
    UZS = value 'UZS'

    # Venezuelan bolívar
    VEF = value 'VEF'

    # Vietnamese dong
    VND = value 'VND'

    # Vanuatu vatu
    VUV = value 'VUV'

    # Samoan tala
    WST = value 'WST'

    # CFA franc BEAC
    XAF = value 'XAF'

    # Silver (one troy ounce)
    XAG = value 'XAG'

    # Gold (one troy ounce)
    XAU = value 'XAU'

    # European Composite Unit(EURCO) (bond market unit)
    XBA = value 'XBA'

    # European Monetary Unit(E.M.U.-6) (bond market unit)
    XBB = value 'XBB'

    # European Unit of Account 9(E.U.A.-9) (bond market unit)
    XBC = value 'XBC'

    # European Unit of Account 17(E.U.A.-17) (bond market unit)
    XBD = value 'XBD'

    # bitcoinInternational internet currency
    XBT = value 'XBT'

    # East Caribbean dollar
    XCD = value 'XCD'

    # Special drawing rights
    XDR = value 'XDR'

    # UIC franc(special settlement currency)
    XFU = value 'XFU'

    # CFA franc BCEAO
    XOF = value 'XOF'

    # Palladium (onetroy ounce)
    XPD = value 'XPD'

    # CFP franc(franc Pacifique)
    XPF = value 'XPF'

    # Platinum (onetroy ounce)
    XPT = value 'XPT'

    # SUCRE
    XSU = value 'XSU'

    # Code reserved for testing purposes
    XTS = value 'XTS'

    # ADB Unit of Account
    XUA = value 'XUA'

    # Yemeni rial
    YER = value 'YER'

    # South African rand
    ZAR = value 'ZAR'

    # Zambian kwacha
    ZMW = value 'ZMW'

    # Zimbabwe dollar
    ZWD = value 'ZWD'
  end
end