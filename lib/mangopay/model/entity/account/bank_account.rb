require_relative '../entity_base'
require_relative '../../../util/non_instantiable'
require_relative '../../enum/account_type'

module MangoModel

  # Bank account entity
  class BankAccount < EntityBase
    extend NonInstantiable

    # [String] Its owning user's ID
    attr_accessor :user_id

    # [AccountType] Its type
    attr_accessor :type

    # [String] Its owner's name
    attr_accessor :owner_name

    # [Address] Its owner's address
    attr_accessor :owner_address

    # [true/false] Whether it's active or not
    attr_accessor :active
  end
end