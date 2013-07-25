module MangoPay
  module HTTPCalls
    module Create
      module ClassMethods

        def create(*id, params)
          id = id.empty? ? nil : id[0]
          response = MangoPay.request(:post, self.url(id), params)
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end

    module Update
      module ClassMethods
        def update(id = nil, params = {})
          response = MangoPay.request(:put, url(id), params)
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end

    module Fetch
      module ClassMethods
        def fetch(id = nil, filters = {})
          response = MangoPay.request(:get, url(id), filters)
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end
