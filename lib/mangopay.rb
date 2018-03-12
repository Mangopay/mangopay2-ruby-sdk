require_relative '../lib/mangopay/common/log_provider'
require_relative 'mangopay/environment'
require_relative 'mangopay/configuration'
require_relative 'mangopay/model/model'
require_relative 'mangopay/api/api'

# Holds top-level configuration.
module MangoPay
  LOG = LogProvider.provide(self)

  VERSION = '4.0.0'.freeze

  SANDBOX_API_URL = 'https://api.sandbox.mangopay.com'.freeze
  MAIN_API_URL = 'https://api.mangopay.com'.freeze

  # ID of the environment in which to run MangoPay operations
  @global_env_id = :default
  # Mapping of MangoPay environments by ID
  @environments = {
    default: MangoPay::Environment.new(:default)
  }
  # Mapping of thread object IDs to MangoPay environment IDs
  @env_id = {}

  class << self

    # Allows to specify environment in which to run MangoPay operations.
    # All subsequent threads will automatically run in that environment.
    #
    # @param +env_id+ ID of the required environment
    #
    # noinspection RubyResolve
    def use_environment(env_id)
      @global_env_id = env_id || :default
      unless @environments[@global_env_id]
        LOG.debug 'Creating new environment :{}', env_id
        env = MangoPay::Environment.new(@global_env_id)
        @environments[@global_env_id] = env
      end
      LOG.info 'Using environment :{}', env_id
      put_thread_local_environment
    end

    # Sets MangoPay to run under the default environment.
    def use_default
      use_environment :default
    end

    # Returns the environment currently being used.
    #
    # noinspection RubyResolve
    def environment
      @environments[thread_local_env_id]
    end

    private

    # Returns the ID of the environment to be used for current thread.
    #
    # noinspection RubyResolve
    def thread_local_env_id
      thread_id = Thread.current.object_id
      @env_id[thread_id] || put_thread_local_environment
    end

    # Saves currently-set global environment as the one to be used
    # for current thread.
    #
    # noinspection RubyResolve
    def put_thread_local_environment
      thread = Thread.current
      thread_id = thread.object_id
      LOG.debug 'Mapping thread {} to environment :{}',
                thread_id, @global_env_id
      initiate_mapping_removal(thread) unless @env_id[thread_id]
      @env_id[thread_id] = @global_env_id
    end

    # Starts another thread which will delete current thread's
    # environment hash entry as soon as current thread terminates.
    #
    # noinspection RubyResolve
    def initiate_mapping_removal(thread)
      thread_id = thread.object_id
      LOG.debug 'Initiating removal task for thread-to-environment mapping '\
                  '{ {} => :{} }', thread_id, @global_env_id
      Thread.new do
        thread.join
        deleted = @env_id.delete thread_id
        LOG.debug 'Removed thread-to-environment mapping '\
                    '{ {} => :{} }', thread_id, deleted
      end
    end

    public

    # Provides MangoPay configuration object for current environment.
    #
    # noinspection RubyResolve
    def configuration
      env = environment
      env.configuration ||
        raise("MangoPay.configure() was not called for environment #{env.id}")
    end

    # Allows configuration of the current MangoPay environment.
    # Yields configuration object to a provided block.
    #
    # noinspection RubyResolve
    def configure
      env = environment
      LOG.info 'Configuring environment :{}', env.id
      config = env.configuration || MangoPay::Configuration.new
      yield config
      validate config
      LOG.info 'Successfully configured environment :{} for client {}',
               env.id, config.client_id
      env.configuration = config
    end

    private

    # Validates a provided MangoPay configuration.
    def validate(config)
      cause_message = 'You must specify your client ID'
      raise cause_message unless config.client_id
      cause_message = 'You must specify your client passphrase'
      raise cause_message unless config.client_passphrase
      config.root_url = config.preproduction? ? SANDBOX_API_URL : MAIN_API_URL\
                          unless config.root_url
    end
  end
end