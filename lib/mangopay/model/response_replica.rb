require_relative '../common/jsonifier'

module MangoModel

  # Replication of a previous request's response
  class ResponseReplica
    include MangoPay::Jsonifier

    # [String] Original response's status code
    attr_accessor :status_code

    # [String] Value of the original response's Content-Length header
    attr_accessor :content_length

    # [String] Value of the original response's Content-Type header
    attr_accessor :content_type

    # [DateTime] Time of request of the original response
    attr_accessor :long_date

    # [Object] The original response object
    attr_accessor :resource

    # [String] URL of the original request
    attr_accessor :request_url
  end
end