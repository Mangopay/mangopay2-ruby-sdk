require_relative '../../common/jsonifier'

# Model object for body of request to deactivate a bank account
class DeactivationRequest
  include MangoPay::Jsonifier

  def initialize
    @active = false
  end
end