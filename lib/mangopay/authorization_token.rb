module MangoPay
  module AuthorizationToken

    class Manager

      class << self
        def storage
          @@storage ||= StaticStorage.new
        end
        def storage= (storage)
          @@storage = storage
        end
      end

      def self.get_token
        token = storage.get
        if token.nil? || token['timestamp'].nil? || token['timestamp'] <= Time.now
          uri = MangoPay.api_uri('/api/oauth/token')
          cfg = MangoPay.configuration
          res = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
            req = Net::HTTP::Post.new(uri.request_uri)
            req.basic_auth cfg.client_id, cfg.client_passphrase
            req.body = 'grant_type=client_credentials'
            http.request req
          end
          token = MangoPay::JSON.load(res.body)
          token['timestamp'] = Time.now + token['expires_in'].to_i
          storage.store token
        end
        token
      end
    end

    class StaticStorage
      def get
        @@token ||= nil
      end
      def store(token)
        @@token = token
      end
    end

    class FileStorage
      require 'yaml'
      @temp_dir

      def initialize(temp_dir = nil)
        @temp_dir = temp_dir || MangoPay.configuration.temp_dir
        if !@temp_dir
          raise "Path to temporary folder is not defined"
        end
      end

      def get
        begin
          f = File.open(file_path, File::RDONLY)
          f.flock(File::LOCK_SH)
          txt = f.read
          f.close
          YAML.load(txt) || nil
        rescue Errno::ENOENT
          nil
        end
      end

      def store(token)
        File.open(file_path, File::RDWR|File::CREAT, 0644) do |f|
          f.flock(File::LOCK_EX)
          f.truncate(0)
          f.rewind
          f.puts(YAML.dump(token))
        end
      end

      def file_path
        File.join(@temp_dir, "MangoPay.AuthorizationToken.FileStore.tmp")
      end
    end
  end
end
