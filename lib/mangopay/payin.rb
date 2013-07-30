module MangoPay
  class PayIn < Resource
    include MangoPay::HTTPCalls::Fetch

    module Card
      class Web < Resource
        include MangoPay::HTTPCalls::Create

        private

        def self.url(id = nil)
          "/v2/#{MangoPay.configuration.client_id}/payins/card/#{CGI.escape(class_name.downcase)}"
        end
      end
    end
  end
end
