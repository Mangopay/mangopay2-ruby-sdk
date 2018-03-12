require_relative '../../common/jsonifier'

# Model object for body of a request to submit a document for approval
class SubmitDocumentRequest
  include MangoPay::Jsonifier

  # [String] Custom data added with the request
  attr_accessor :tag

  def initialize(tag = nil)
    self.tag = tag
    @status = MangoModel::DocumentStatus::VALIDATION_ASKED
  end
end