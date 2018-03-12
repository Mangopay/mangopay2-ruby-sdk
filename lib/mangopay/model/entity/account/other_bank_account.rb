require_relative 'bank_account'
require_relative '../../enum/account_type'
require_relative '../../../common/jsonifier'

module MangoModel

  # Bank account of +AccountType::OTHER+
  class OtherBankAccount < BankAccount
    include MangoPay::Jsonifier

    # [String] Its BIC code
    attr_accessor :bic

    # [String] Its account number
    attr_accessor :account_number

    # [CountryIso] Its country
    attr_accessor :country

    def initialize
      self.type = MangoModel::AccountType::OTHER
    end
  end
end