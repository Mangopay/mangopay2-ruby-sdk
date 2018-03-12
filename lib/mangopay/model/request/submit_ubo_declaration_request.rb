require_relative '../../common/jsonifier'

# Model object for body of request to submit a UBO declaration for approval
class SubmitUboDeclarationRequest
  include MangoPay::Jsonifier

  # [String] Custom data added with the request
  attr_accessor :tag

  def initialize(tag = nil)
    self.tag = tag
    @status = MangoModel::UboDeclarationStatus::VALIDATION_ASKED
  end
end