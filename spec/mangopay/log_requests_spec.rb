describe MangoPay do
  include_context 'users'

  describe 'all requests' do

    let(:log_file) do
      File.join(MangoPay.configuration.temp_dir, 'mangopay.log.tmp')
    end

    it 'doesnt log requests by default' do
      FileUtils.rm_f(log_file)
      MangoPay.configuration.log_file = nil
      new_natural_user
      expect(File.exists? log_file).to be(false)
    end

    it 'if log file is configured, log requests and responses' do
      FileUtils.rm_f(log_file)
      MangoPay.configuration.log_file = log_file
      new_natural_user
      expect(File.exists? log_file).to be(true)
      FileUtils.rm_f(log_file)
    end

  end
end
