module MangoPay
  module HTTPCalls
    module Create
      module ClassMethods
        def create(params={})
          response = MangoPay.request(:post, self.url, params)
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end

    module Update
      module ClassMethods
        def update(id, params = {})
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
