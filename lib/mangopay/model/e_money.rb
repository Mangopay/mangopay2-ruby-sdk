require_relative '../common/jsonifier'

module MangoModel

  # Represents a user's e-money.
  class EMoney
    include MangoPay::Jsonifier

    # [String] Its owner's ID
    attr_accessor :user_id

    # [Money] The amount of money that has been credited to its owner
    attr_accessor :credited_e_money

    # [Money] The amount of money that has been debited from its owner
    attr_accessor :debited_e_money
  end
end