require_relative '../../common/jsonifier'

# Model object for body of request to submit a UBO declaration for approval
class SubmitUboDeclarationRequest
  include MangoPay::Jsonifier

  # Id of the ubo declaration
  attr_accessor :id
  # [String] Custom data added with the request
  attr_accessor :tag

  def initialize(id, tag = nil)
    self.id = id
    self.tag = tag
    @status = MangoModel::UboDeclarationStatus::VALIDATION_ASKED
  end
end