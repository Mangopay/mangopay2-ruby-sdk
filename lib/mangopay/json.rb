# We can use MultiJson directly , why do we even have this module ?
module MangoPay
  module JSON
    class << self
      def dump(*args)
        MultiJson.dump(*args)
      end

      def load(*args)
        MultiJson.load(*args)
      end
    end
  end
end
