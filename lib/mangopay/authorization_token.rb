module MangoPay
  module AuthorizationToken

    # See http://docs.mangopay.com/api-references/authenticating/
    class Manager

      class << self
        def storage
          @@storage ||= StaticStorage.new
        end

        def storage= (storage)
          @@storage = storage
        end

        def get_token
          token = storage.get
          env_key = get_environment_key_for_token
          if token.nil? || token['timestamp'].nil? || token['timestamp'] <= Time.now || token['environment_key'] != env_key
            token = MangoPay.request(:post, "/#{MangoPay.version_code}/oauth/token", {}, {}, {}, Proc.new do |req|
              cfg = MangoPay.configuration
              req.basic_auth cfg.client_id, cfg.client_apiKey
              req.body = 'grant_type=client_credentials'
              req.add_field('Content-Type', 'application/x-www-form-urlencoded')
            end)
            token['timestamp'] = Time.now + (token['expires_in'].to_i - 10)
            token['environment_key'] = env_key
            storage.store token
          end
          token
        end

        def get_environment_key_for_token
          cfg = MangoPay.configuration
          key = "#{cfg.root_url}|#{cfg.client_id}|#{cfg.client_apiKey}"
          key = Digest::MD5.hexdigest(key)
          key
        end
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
          YAML.safe_load(txt, permitted_classes: [Time]) || nil
        rescue Errno::ENOENT
          nil
        end
      end

      def store(token)
        File.open(file_path, File::RDWR | File::CREAT, 0644) do |f|
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
