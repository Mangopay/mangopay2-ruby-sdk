require_relative '../transaction'
require_relative '../../../util/non_instantiable'

module MangoModel

  # Pay In entity
  class PayIn < Transaction
    extend NonInstantiable

    # [PayInPaymentType] Its type
    attr_accessor :payment_type

    # [PayInExecutionType] Its execution type
    attr_accessor :execution_type
  end
end