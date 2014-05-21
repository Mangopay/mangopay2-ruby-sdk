module MangoPay
  class Client < Resource

    def self.create(params)
      MangoPay.request(:post, '/api/clients/', params, {}, {
        'user_agent' => "MangoPay V2 RubyBindings/#{VERSION}",
        'Content-Type' => 'application/json'
      })
    end
  end
end
