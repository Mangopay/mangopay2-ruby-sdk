module MangoPay
  class Client < Resource
    def self.create(params)
      uri = URI(MangoPay.configuration.root_url + '/api/clients/')
      res = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
        puts uri.request_uri
        request = Net::HTTP::Post.new(uri.request_uri, {
          'user_agent' => "MangoPay V1 RubyBindings/#{MangoPay::VERSION}",
          'Content-Type' => 'application/json'
        })
        request.body = MangoPay::JSON.dump(params)
        http.request request
      end
      MangoPay::JSON.load(res.body)
    end
  end
end
