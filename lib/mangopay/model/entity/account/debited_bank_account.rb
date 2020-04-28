require_relative '../entity_base'
require_relative '../../../util/non_instantiable'
require_relative '../../enum/account_type'

module MangoModel

  # Debited bank account entity
  class DebitedBankAccount < EntityBase
    extend NonInstantiable

    # [String] Its owner's name
    attr_accessor :owner_name

    # [String] Its account number
    attr_accessor :account_number

    # [String] Its iban
    attr_accessor :iban

    # [String] Its bic
    attr_accessor :bic

    # [String] Its country
    attr_accessor :country

    # [AccountType] Its type
    attr_accessor :type
  end
end