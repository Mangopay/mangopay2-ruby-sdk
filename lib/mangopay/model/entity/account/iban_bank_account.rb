require_relative 'bank_account'
require_relative '../../enum/account_type'
require_relative '../../../common/jsonifier'

module MangoModel

  # Bank account of +AccountType::IBAN+
  class IbanBankAccount < BankAccount
    include MangoPay::Jsonifier

    # [String] Its IBAN code
    attr_accessor :iban

    # [String] Its BIC code
    attr_accessor :bic

    def initialize
      self.type = MangoModel::AccountType::IBAN
    end
  end
end