module MangoPay

  # Provides API methods for the UBO declaration entity.
  class UboDeclaration < Resource
    include HTTPCalls::Fetch

    class << self

      def update(id = nil, params = {})
        declared_ubo_ids = []
        params['DeclaredUBOs'].each do |ubo|
          declared_ubo_ids << (ubo.key?('UserId') ? ubo['UserId'] : ubo)
        end
        params['DeclaredUBOs'] = declared_ubo_ids
        MangoPay.request(:put, url(id), params)
      end
    end
  end
end