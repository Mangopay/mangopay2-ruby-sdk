module MangoPay
  class Client < Resource

    def self.create(params)
      MangoPay.request(:post, '/api/clients/', params, {}, {
        'user_agent' => "MangoPay V1 RubyBindings/#{MangoPay::VERSION}",
        'Content-Type' => 'application/json'
      })
    end
  end
end
