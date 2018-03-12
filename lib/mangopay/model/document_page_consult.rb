require_relative '../common/jsonifier'

module MangoModel

  # Holds document page viewing data
  class DocumentPageConsult
    include MangoPay::Jsonifier

    # [String] URL where this document page can be viewed
    attr_accessor :url

    # [Integer] Time when the page consult will expire (UNIX timestamp)
    attr_accessor :expiration_date
  end
end