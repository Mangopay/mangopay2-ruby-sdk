require_relative 'bank_account'
require_relative '../../enum/account_type'
require_relative '../../../common/jsonifier'

module MangoModel

  # Bank account of +AccountType::CA+
  class CaBankAccount < BankAccount
    include MangoPay::Jsonifier

    # [String] Its institution number (3-4 digits)
    attr_accessor :institution_number

    # [String] Its account number (max 20 digits)
    attr_accessor :account_number

    # [String] Its bank's branch code (5 digits)
    attr_accessor :branch_code

    # [String] Its bank's name (max 50 letters/digits)
    attr_accessor :bank_name

    def initialize
      self.type = AccountType::CA
    end
  end
end