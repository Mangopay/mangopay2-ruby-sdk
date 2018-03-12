require 'base64'

# Encodes files
module FileEncoder
  class << self

    # Encodes a file to a Base64 string.
    #
    # @param +path+ [String] path to the file to be encoded
    # @return [String] the file as a Base64-encoded string
    def encode_base64(path)
      data = File.open(path, 'rb', &:read)
      Base64.strict_encode64 data
    end
  end
end