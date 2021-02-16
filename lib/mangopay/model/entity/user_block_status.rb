require_relative '../../common/jsonifier'

module MangoModel

  # UserBlockStatus entity
  class UserBlockStatus < EntityBase
    include MangoPay::Jsonifier

    attr_accessor :scope_blocked

    attr_accessor :action_code
  end
end