require_relative '../../../common/jsonifier'

module MangoModel

  # Allows payment through a card for which the action has
  # been pre-authorized
  class CardPreAuthorizedPayIn < PayIn
    include MangoPay::Jsonifier

    # [String] ID of the corresponding pre-authorization
    attr_accessor :preauthorization_id
  end
end