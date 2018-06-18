require 'fileutils'
require_relative '../common/log_provider'

module MangoApi

  # Manages acquisition and storage of API authorization token.
  module AuthTokenManager
    LOG = MangoPay::LogProvider.provide(self)

    class << self

      # Provides a valid authorization token for API calls.
      def token
        client_id = MangoPay.configuration.client_id
        token_valid? && storage.retrieve_for(client_id) || refresh_token
      end

      # Returns true if the current client's
      # authorization token is valid
      def token_valid?
        !token_invalid?
      end

      private

      # Retrieves authorization token storage object.
      def storage
        return @storage if @storage
        init_storage
      end

      # Initializes storage strategy for OAuth tokens.
      # Returns the storage object.
      def init_storage
        client_id = MangoPay.configuration.client_id
        dir = MangoPay.configuration.temp_dir
        @storage = dir ? FileStorage.new : MemoryStorage.new
        strategy = @storage.class.name.split('::').last
        location_if_file = dir ? " at '/#{dir}'" : ''
        LOG.info 'Using {}{} for {} client\'s OAuth tokens',
                 strategy, location_if_file, client_id
        @storage
      end

      # Returns true if the current client's
      # stored token is no longer valid.
      def token_invalid?
        token = storage.retrieve_for MangoPay.configuration.client_id
        token.nil? ||
          token['expire_time'].nil? ||
          token['expire_time'] <= Time.now ||
          token['environment_key'] != environment_key
      end

      # Provides a configuration-specific hash key.
      def environment_key
        config = MangoPay.configuration
        key = [config.root_url, config.client_id, config.client_passphrase]
              .join('|')
        Digest::MD5.hexdigest(key)
      end

      # Refreshes the stored authorization token.
      def refresh_token
        LOG.info 'Refreshing OAuth token'
        config = MangoPay.configuration
        unless config.client_id && config.client_passphrase
          raise 'You must specify your client ID and passphrase'
        end
        token = MangoApi::OAuthTokens.create(config)
        append_data token
        store_token token
        token
      end

      # Appends some useful data to the token object.
      #
      # @param +token+ the token object
      def append_data(token)
        token['expire_time'] = Time.now + token['expires_in'].to_i
        token['environment_key'] = environment_key
      end

      # Stores the OAuth token.
      #
      # @param +token+ the OAuth token to be stored
      def store_token(token)
        client_id = MangoPay.configuration.client_id
        storage.store_for client_id, token
        LOG.info 'OAuth token stored in {} for client {}',
                 storage.class.name.split('::').last, client_id
      end
    end
  end

  # Stores client-specific OAuth tokens in-memory.
  class MemoryStorage
    def initialize
      @token = {}
    end

    # Retrieves a client-specific OAuth token.
    #
    # @param +client_id+ ID of the client whose token to retrieve
    def retrieve_for(client_id)
      @token[client_id]
    end

    # Stores a client-specific OAuth token.
    #
    # @param +client_id+ ID of the client for which token is being stored
    # @param +token+ OAuth token for this client
    def store_for(client_id, token)
      @token[client_id] = token
    end
  end

  # Stores client-specific OAuth tokens in temporary files
  # in the user-specified directory.
  class FileStorage
    require 'yaml'

    def initialize
      @temp_dir = MangoPay.configuration.temp_dir
      raise 'Path to temporary folder is not defined' unless @temp_dir
    end

    # Retrieves a client's OAuth token from its storage file.
    #
    # @param +client_id+ ID of the client whose OAuth token to retrieve
    #
    # noinspection RubyResolve
    def retrieve_for(client_id)
      path = file_path(client_id)
      return nil unless File.exist? path
      File.open(path, 'r') do |file|
        file.flock File::LOCK_SH
        oauth_data = file.read
        YAML.load oauth_data || nil
      end
    end

    # Generates the file path to a certain client's OAuth token file.
    #
    # @param +client_id+ ID of the client whose file path to generate
    def file_path(client_id)
      File.join(@temp_dir, "mangopay_oauth_token_#{client_id}.tmp")
    end

    # Stores client-specific OAuth token in its own file.
    #
    # @param +client_id+ ID of the client whose token is being stored
    # @param +token+ OAuth token for this client
    #
    # noinspection RubyResolve
    def store_for(client_id, token)
      ensure_folder_exists MangoPay.configuration.temp_dir
      File.open(file_path(client_id), 'w') do |file|
        file.flock File::LOCK_EX
        file.truncate(0)
        file.rewind
        file.puts YAML.dump(token)
      end
    end

    # Creates a folder at the given path if none exists.
    #
    # @param +folder+ path at which folder should exist
    def ensure_folder_exists(folder)
      FileUtils.mkdir_p folder unless File.directory?(folder)
    end
  end
end
