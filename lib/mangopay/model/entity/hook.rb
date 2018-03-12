require_relative '../../common/jsonifier'

module MangoModel

  # Hook entity
  # Once setup, a hook entity allows MangoPay to make a request
  # to a specific URL on the implementing server to make it aware
  # of various Events (i.e. a failed PayOut). One URL can be
  # configured for each +EventType+.
  class Hook < EntityBase
    include MangoPay::Jsonifier

    # [String] The URL that will be pinged for events of the
    # specified type
    attr_accessor :url

    # [HookStatus] Whether or not the hook is enabled
    attr_accessor :status

    # [HookValidity] Whether or not the hook is valid
    attr_accessor :validity

    # [EventType] Type of event handled
    attr_accessor :event_type
  end
end