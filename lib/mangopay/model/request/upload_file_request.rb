require_relative '../../common/jsonifier'

# Model object for body of request to upload a file
class UploadFileRequest
  include MangoPay::Jsonifier

  # [String] Base64-encoded file to be uploaded
  attr_accessor :file
end