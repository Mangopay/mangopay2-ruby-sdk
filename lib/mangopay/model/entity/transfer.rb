require_relative '../../common/jsonifier'

module MangoModel

  # Transfer entity
  # A Transfer is a request to relocate e-money
  # from one wallet to another
  class Transfer < Transaction
    include MangoPay::Jsonifier

    # API docs specify identical fields in Transfer and Transaction.
  end
end