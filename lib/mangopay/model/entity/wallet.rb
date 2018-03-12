require_relative '../../common/jsonifier'

module MangoModel

  # Wallet entity
  # A Wallet is an object in which PayIns and Transfers from
  # users are stored in order to collect money. Wallets can
  # be paid into, funds can be withdrawn from them or transferred
  # from one Wallet to another.
  class Wallet < EntityBase
    include MangoPay::Jsonifier

    # [Array] Its owners (currently only one may be specified)
    attr_accessor :owners

    # [Money] Its current balance
    attr_accessor :balance

    # [FundsType] Its funds' type
    attr_accessor :funds_type

    # [String] Its description
    attr_accessor :description

    # [CurrencyIso] Its funds' currency
    attr_accessor :currency
  end
end