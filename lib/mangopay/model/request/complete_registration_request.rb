require_relative '../../common/jsonifier'

# Model object for body of request to complete a card registration
class CompleteRegistrationRequest
  include MangoPay::Jsonifier

  # [String] Registration key received from the Tokenization Server
  attr_accessor :registration_data

  def initialize(registration_data)
    self.registration_data = registration_data
  end
end