require_relative '../common/jsonifier'

module MangoModel

  # Models a financial sum
  class Money
    include MangoPay::Jsonifier

    # [CurrencyIso] Currency in which the sum is represented
    attr_accessor :currency

    # [Integer] The amount of money in the smallest sub-division of the currency
    #           e.g. 12.60 EUR would be represented as 1260 whereas 12 JPY
    # would be represented as just 12
    attr_accessor :amount
  end
end