require_relative '../common/jsonifier'

# Filtering object for reports
class ReportFilter
  include MangoPay::Jsonifier

  #
  # COMMON
  #

  # [Integer] Only include resources with CreationDate
  # before this time (UNIX timestamp)
  attr_accessor :before_date

  # [Integer] Only include resources with CreationDate
  # after this time (UNIX timestamp)
  attr_accessor :after_date

  #
  # TRANSACTION
  #

  # [Array] Only include transactions of these +TransactionType+s
  attr_accessor :type

  # [Array] Only include transactions with these +TransactionStatus+es
  attr_accessor :status

  # [Array] Only include transactions of these +TransactionNature+s
  attr_accessor :nature

  # [Integer] The minimum amount of debited funds
  attr_accessor :min_debited_funds_amount

  # [CurrencyIso] The currency of minimum debited funds
  attr_accessor :min_debited_funds_currency

  # [Integer] The maximum amount of debited funds
  attr_accessor :max_debited_funds_amount

  # [CurrencyIso] The currency of maximum debited funds
  attr_accessor :max_debited_funds_currency

  # [Integer] The minimum amount of fees
  attr_accessor :min_fees_amount

  # [CurrencyIso] The currency of minimum fees
  attr_accessor :min_fees_currency

  # [Integer] The maximum amount of fees
  attr_accessor :max_fees_amount

  # [CurrencyIso] The currency of maximum fees
  attr_accessor :max_fees_currency

  # [String] Only include resources with this author ID
  attr_accessor :author_id

  # [String] Only include resources with this wallet ID
  attr_accessor :wallet_id

  #
  # WALLET
  #

  # [String] Only include wallets having owner with this ID
  attr_accessor :owner_id

  # [CurrencyIso] Only include wallets of this currency
  attr_accessor :currency

  # [Integer] The minimum balance of wallets to include
  attr_accessor :min_balance_amount

  # [CurrencyIso] The currency of minimum balance
  attr_accessor :min_balance_currency

  # [Integer] The maximum balance of wallets to include
  attr_accessor :max_balance_amount

  # [CurrencyIso] The currency of maximum balance
  attr_accessor :max_balance_currency
end