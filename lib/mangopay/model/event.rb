require_relative '../common/jsonifier'

module MangoModel

  # The Event entity
  class Event
    include MangoPay::Jsonifier

    # [String] Its ID
    attr_accessor :resource_id

    # [Integer] Time when the event happened (UNIX timestamp)
    attr_accessor :date

    # [EventType] Its type
    attr_accessor :event_type
  end
end