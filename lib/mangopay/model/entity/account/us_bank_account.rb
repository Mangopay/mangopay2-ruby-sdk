require_relative 'bank_account'
require_relative '../../enum/account_type'
require_relative '../../../common/jsonifier'

module MangoModel

  # Bank account of +AccountType::US+
  class UsBankAccount < BankAccount
    include MangoPay::Jsonifier

    # [String] Its account number (digits only)
    attr_accessor :account_number

    # [String] Its ABA (9 digits )
    attr_accessor :aba

    # [DepositType] Its deposit type
    attr_accessor :deposit_account_type

    def initialize
      self.type = MangoModel::AccountType::US
    end
  end
end