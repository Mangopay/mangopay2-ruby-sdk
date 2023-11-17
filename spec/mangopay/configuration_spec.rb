describe MangoPay::Configuration do

  it 'fails when calling with wrong client credentials' do
    expect {
      c = MangoPay.configuration
      c.client_id = 'test_asd'
      c.client_apiKey = '00000'
      MangoPay::User.fetch()
    }.to raise_error { |err|
        expect(err).to be_a MangoPay::ResponseError
        expect(err.code).to eq '401'
        expect(err.message).to eq 'invalid_client'
      }
  end

  it 'fails when calling with wrong client credentials, but succeeds after applying a new (correct) config' do
    # create a wrong configuration
    wrong_config = MangoPay::Configuration.new
    wrong_config.client_id = 'placeholder'
    wrong_config.client_apiKey = '0000'
    wrong_config.preproduction = true

    # create a valid configuration
    valid_config = MangoPay::Configuration.new
    valid_config.client_id = 'sdk-unit-tests'
    valid_config.client_apiKey = 'cqFfFrWfCcb7UadHNxx2C9Lo6Djw8ZduLi7J9USTmu8bhxxpju'
    valid_config.preproduction = true

    # add the 2 configs to the list of MangoPay configs
    MangoPay.add_config('wrong', wrong_config)
    MangoPay.add_config('valid', valid_config)

    # apply wrong config
    MangoPay.get_config('wrong').apply_configuration

    expect {
      MangoPay::User.fetch()
    }.to raise_error { |err|
      expect(err).to be_a MangoPay::ResponseError
      expect(err.code).to eq '401'
      expect(err.message).to eq 'invalid_client'
    }

    # apply valid configuration
    MangoPay.get_config('valid').apply_configuration

    # expect success
    users = MangoPay::User.fetch()
    expect(users).to be_kind_of(Array)
  end

  it 'fails when fetching a config that does not exist' do
    expect {
      MangoPay.get_config('placeholder')
    }.to raise_error { |err|
      expect(err).to be_a RuntimeError
      expect(err.message).to eq "Could not find any configuration with name 'placeholder'"
    }
  end

  it 'succeeds when removing config' do
    wrong_config = MangoPay::Configuration.new
    wrong_config.client_id = 'placeholder'
    wrong_config.client_apiKey = '0000'
    wrong_config.preproduction = true

    MangoPay.add_config('wrong', wrong_config)

    # pass when fetching config before removing it
    MangoPay.get_config('wrong')

    # remove config
    MangoPay.remove_config('wrong')

    # fail when trying to fetch after removal
    expect {
      MangoPay.get_config('wrong')
    }.to raise_error { |err|
      expect(err).to be_a RuntimeError
      expect(err.message).to eq "Could not find any configuration with name 'wrong'"
    }
  end

  it 'goes ok when calling with correct client credentials' do
    reset_mangopay_configuration
    users = MangoPay::User.fetch()
    expect(users).to be_kind_of(Array)
  end

  describe '.use_ssl?' do
    let(:configuration) { MangoPay::Configuration.new }

    it 'defaults to true' do
      expect(configuration.use_ssl?).to eq(true)
    end

    context 'when assigned to false in production' do
      before do
        configuration.use_ssl = false
        configuration.preproduction = false
      end

      it 'uses true as value' do
        expect(configuration.use_ssl?).to eq(true)
      end
    end

    context 'when assigned to false in preproduction' do
      before do
        configuration.use_ssl = false
        configuration.preproduction = true
      end

      it 'uses assigned as value' do
        expect(configuration.use_ssl?).to eq(false)
      end
    end
  end

  describe '.snakify_response_keys??' do
    let(:configuration) { MangoPay::Configuration.new }

    it 'defaults to false' do
      expect(configuration.snakify_response_keys?).to eq(false)
    end
  end


  describe 'logger' do
    around(:each) do |example|
      c = MangoPay.configuration
      c.logger = logger
      c.log_file = log_file
      example.run
      c.logger = nil
      c.log_file = nil
      MangoPay.instance_variable_set(:@logger, nil)
    end

    context 'when the logger is set' do
      let(:logger) { Logger.new(STDOUT) }

      context 'when the log_file is set' do
        let(:log_file) { File.join(MangoPay.configuration.temp_dir, 'mangopay.log.tmp') }

        it 'initializes the logger using the logger option' do
          expect(MangoPay.send(:logger).instance_variable_get(:@logdev).dev).to(eq(STDOUT))
        end
      end

      context 'when the log_file is not set' do
        let(:log_file) { nil }

        it 'initializes the logger using the logger option' do
          expect(MangoPay.send(:logger).instance_variable_get(:@logdev).dev).to(eq(STDOUT))
        end
      end
    end

    context 'when the logger is not set' do
      let(:logger) { nil }

      context 'when the log_file is set' do
        let(:log_file) { File.join(MangoPay.configuration.temp_dir, 'mangopay.log.tmp') }

        it 'initializes the logger using the log file' do
          expect(MangoPay.send(:logger).instance_variable_get(:@logdev).dev).to(be_an_instance_of(File))
        end
      end

      context 'when the log_file is not set' do
        let(:log_file) { nil }

        it 'raises an error' do
          expect{ MangoPay.send(:logger) }.to raise_error NotImplementedError
        end
      end
    end
  end

  context 'with multithreading' do
    after :all do
      reset_mangopay_configuration
    end

    before :all do
      MangoPay.configuration.client_id = 'default'

      thread_a = Thread.new do
        @default_client_id = MangoPay.configuration.client_id

        MangoPay.configuration.client_id = 'a'

        # Test #configuration= & #configuration
        config = MangoPay::Configuration.new
        config.client_id = 'a'
        MangoPay.configuration = config
        @before_client_id = MangoPay.configuration.client_id

        # Test multithreading
        sleep 1 # Waits for thread B to do its business
        @after_client_id  = MangoPay.configuration.client_id

        # Test #configure
        MangoPay.configure do |c|
          c.client_id = 'configured'
        end
        @configured_client_id = MangoPay.configuration.client_id

        # Test #with_config
        @before_with_config_client_id = MangoPay.configuration.client_id
        config = MangoPay::Configuration.new
        config.client_id = 'with_config'
        MangoPay.with_configuration(config) do
          @with_config_client_id = MangoPay.configuration.client_id
        end
        @after_with_config_client_id = MangoPay.configuration.client_id
      end

      thread_b = Thread.new do
        # Thread A does its business
        sleep 0.5
        @thread_b_default_client_id = MangoPay.configuration.client_id

        # Will it impact the configuration in thread A ?
        MangoPay.configuration.client_id = 'b'
      end

      # Wait for both threads to complete
      thread_a.join
      thread_b.join
    end

    it '#configuration & #configuration=' do
      expect(@before_client_id).to eq('a')
    end

    it '#configure' do
      expect(@configured_client_id).to eq('configured')
    end

    it '#with_configuration' do
      expect(@with_config_client_id).to eq('with_config')
      expect(@after_with_config_client_id).to eq(@before_with_config_client_id)
    end

    context "since configurations are thread-local," do
      it 'threads get the last configuration set as default config.' do
        expect(@default_client_id).to eq('default')
        expect(@thread_b_default_client_id).to eq('a')
      end

      it "configurations are isolated from other threads' activity." do
        expect(@after_client_id).to eq('a')
      end
    end
  end
end
