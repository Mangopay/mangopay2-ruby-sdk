require_relative '../../common/jsonifier'

module MangoModel

  # Client Wallet entity
  # The Client Wallet is very similar to a normal Wallet except the parameters
  # +description+ and +owners+ are removed. Currently, there are two types of
  # Client Wallet (specified by the +funds_type+ parameter) - +FEES+ where your
  # collected turnover is stored and +CREDIT_ where repudiations are taken from.
  # A normal wallet for a user has the +FundsType+ of +DEFAULT+.
  class ClientWallet < EntityBase
    include MangoPay::Jsonifier

    # [Money] Its current balance
    attr_accessor :balance

    # [FundsType] Its funds' type
    attr_accessor :funds_type

    # [CurrencyIso] Its funds' currency
    attr_accessor :currency
  end
end