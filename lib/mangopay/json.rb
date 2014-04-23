module MangoPay
  module JSON
    class << self
      if MultiJson.respond_to?(:dump)
        def dump(*args)
          MultiJson.dump(*args)
        end

        def load(*args)
          MultiJson.load(*args)
        end
      else
        def dump(*args)
          MultiJson.encode(*args)
        end

        def load(*args)
          MultiJson.decode(*args)
        end
      end
    end
  end
end
