require_relative '../../common/jsonifier'

# Model object of request to cancel an action
class CancelRequest
  include MangoPay::Jsonifier

  # [String] Custom data to add with the operation
  attr_accessor :tag

  # [PaymentStatus] +CANCELED+ payment status
  attr_accessor :payment_status

  def initialize
    self.payment_status = MangoModel::PaymentStatus::CANCELED
  end
end