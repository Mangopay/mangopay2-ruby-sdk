module Mangopay
  class MangoPayObject
    include Enumerable

    def initialize
    end

    def metaclass
      class << self; self; end
    end
  end
end
