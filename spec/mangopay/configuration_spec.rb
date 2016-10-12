describe MangoPay::Configuration do

  it 'fails when calling with wrong client credentials' do
    expect {
      c = MangoPay.configuration
      c.client_id = 'test_asd'
      c.client_passphrase = '00000'
      MangoPay::User.fetch()
    }.to raise_error(MangoPay::ResponseError)
  end

  it 'goes ok when calling with correct client credentials' do
    reset_mangopay_configuration
    users = MangoPay::User.fetch()
    expect(users).to be_kind_of(Array)
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
