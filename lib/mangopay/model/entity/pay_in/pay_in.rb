require_relative '../transaction'
require_relative '../../../util/non_instantiable'

module MangoModel

  # Pay In entity
  class PayIn < Transaction
    extend NonInstantiable

    # [PayInPaymentType] Its type
    attr_accessor :payment_type

    # [CultureCode] The language to use for the payment page
    attr_accessor :culture

    # [PayInExecutionType] Its execution type
    attr_accessor :execution_type
  end
end