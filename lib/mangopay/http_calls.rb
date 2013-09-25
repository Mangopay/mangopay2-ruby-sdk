module MangoPay
  module HTTPCalls
    module Create
      module ClassMethods

        def create(*id, params)
          id = id.empty? ? nil : id[0]
          response = MangoPay.request(:post, url(id), params)
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

        # - Fetching single entity by +id+:
        # 
        #   MangoPay::User.fetch("user-id") # => {"FirstName"=>"Mango", "LastName"=>"Pay", ...}
        # 
        # - Fetching multiple entities with _optional_ +filters+ hash,
        #   including _pagination_ params
        #   (+page+, +per_page+; see http://docs.mangopay.com/api-references/pagination/):
        #   
        #   MangoPay::User.fetch() # => [{...}, ...]: list of user data hashes (10 per page by default)
        #   MangoPay::User.fetch({'page' => 2, 'per_page' => 3}) # => list of 3 hashes from 2nd page
        # 
        # - For paginated queries the +filters+ param will be supplemented by +total_pages+ and +total_items+ info:
        #   
        #   MangoPay::User.fetch(filter = {'page' => 2, 'per_page' => 3})
        #   filter # => {"page"=>2, "per_page"=>3, "total_pages"=>1969, "total_items"=>5905}
        #
        def fetch(id_or_filters = nil)
          id, filters = MangoPay::HTTPCalls::Fetch.parse_id_or_filters(id_or_filters)
          response = MangoPay.request(:get, url(id), {}, filters)
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end

      def self.parse_id_or_filters(id_or_filters = nil)
        id_or_filters.is_a?(Hash) ? [nil, id_or_filters] : [id_or_filters, {}]
      end
    end

    module Refund
      module ClassMethods
        def refund(id = nil, params = {})
          MangoPay.request(:post, url(id) + '/refunds', params)
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end
