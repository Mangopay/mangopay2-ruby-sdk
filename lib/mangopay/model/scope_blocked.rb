require_relative '../common/jsonifier'

module MangoModel

  class ScopeBlocked
    include MangoPay::Jsonifier

    attr_accessor :inflows

    attr_accessor :outflows
  end
end