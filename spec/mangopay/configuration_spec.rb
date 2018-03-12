require_relative '../spec_helper'
require_relative '../../lib/mangopay'
require_relative '../../lib/mangopay/api/service/users'
require_relative '../../lib/mangopay/model/entity/user/natural_user'

describe MangoPay::Configuration do

  let(:thread_environment_hash) { retrieve_thread_env_hash }

  after :all do
    MangoPay.use_default
    reconfig_mangopay
  end

  context 'without specifying environment' do

    it 'automatically runs on :default environment' do
      expect(MangoPay.environment.id).to be :default
    end
  end

  context 'when specifying multiple environments' do
    describe 'storing configurations' do
      CLIENT_ID1 = 'CLIENT_ID1'.freeze
      CLIENT_ID2 = 'CLIENT_ID2'.freeze
      CLIENT_PASS1 = 'CLIENT_PASS1'.freeze
      CLIENT_PASS2 = 'CLIENT_PASS2'.freeze

      it 'is done environment-specifically' do
        MangoPay.use_environment :env1
        MangoPay.configure do |config|
          config.client_id = CLIENT_ID1
          config.client_passphrase = CLIENT_PASS1
        end
        MangoPay.use_environment :env2
        MangoPay.configure do |config|
          config.client_id = CLIENT_ID2
          config.client_passphrase = CLIENT_PASS2
        end

        MangoPay.use_environment :env1
        config = MangoPay.configuration
        expect(config.client_id).to be CLIENT_ID1
        expect(config.client_passphrase).to be CLIENT_PASS1

        MangoPay.use_environment :env2
        config = MangoPay.configuration
        expect(config.client_id).to be CLIENT_ID2
        expect(config.client_passphrase).to be CLIENT_PASS2
      end
    end

    context 'across multiple threads' do
      describe 'switching environments' do

        it 'is done thread-independently' do
          MangoPay.use_environment :env1
          thread = Thread.new do
            MangoPay.use_environment :env2
            expect(MangoPay.environment.id).to be :env2
          end
          thread.join
          expect(MangoPay.environment.id).to be :env1
          # allow background threads to terminate
          sleep 0.05
        end
      end

      describe 'new thread-to-environment mappings' do
        it 'live only as long as the threads' do
          thread = Thread.new do
            MangoPay.use_environment :env1
            thread_id = Thread.current.object_id
            expect(thread_environment_hash[thread_id]).to be :env1
          end
          thread.join
          # allow any post-thread-death actions to execute
          sleep 0.05
          expect(thread_environment_hash[thread.object_id]).to be_nil
        end

        context 'unless environment is switched' do
          it 'are to the same environment' do
            MangoPay.use_environment :env1

            thread_id = Thread.current.object_id
            expect(thread_environment_hash[thread_id]).to be :env1

            thread = Thread.new do
              # request an environment to be assigned to thread
              MangoPay.environment
              thread_id = Thread.current.object_id
              expect(thread_environment_hash[thread_id]).to be :env1
            end
            thread.join

            MangoPay.use_environment :env2

            thread_id = Thread.current.object_id
            expect(thread_environment_hash[thread_id]).to be :env2

            thread = Thread.new do
              MangoPay.environment
              thread_id = Thread.current.object_id
              expect(thread_environment_hash[thread_id]).to be :env2
            end
            thread.join
            # allow background threads to terminate
            sleep 0.05
          end
        end
      end
    end
  end
end

# Gets the thread-to-environment ID hash from the MangoPay module.
#
# noinspection RubyResolve
def retrieve_thread_env_hash
  result = nil
  MangoPay.instance_eval do
    result = @env_id
  end
  result
end