require_relative '../../common/jsonifier'

# Model object for body of request to represent results in a certain currency.
class CurrencyRequest
  include MangoPay::Jsonifier

  # [CurrencyIso] the currency in which to represent results
  attr_accessor :currency

  def initialize(currency)
    self.currency = currency
  end
end