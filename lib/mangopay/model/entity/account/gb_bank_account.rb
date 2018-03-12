require_relative 'bank_account'
require_relative '../../enum/account_type'
require_relative '../../../common/jsonifier'

module MangoModel

  # Bank account of +AccountType::GB+
  class GbBankAccount < BankAccount
    include MangoPay::Jsonifier

    # [String] Its sort code (6 digits)
    attr_accessor :sort_code

    # [String] Its account number (8 digits)
    attr_accessor :account_number

    def initialize
      self.type = MangoModel::AccountType::GB
    end
  end
end