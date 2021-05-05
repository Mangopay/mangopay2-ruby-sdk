describe MangoPay do
  include_context 'users'
  include_context 'payins'
  require 'json'

  describe 'requests log file' do

    let(:log_file) do
      File.join(MangoPay.configuration.temp_dir, 'mangopay.log.tmp')
    end

    it 'filters confidential parameters' do
      FileUtils.rm_f(log_file)
      MangoPay.configuration.log_file = log_file
      created = new_card_registration
      lines = File.open(log_file).select { |l| l.include?('AccessKey') }
      lines.each do |line|
        result = JSON.load(/({.+})\s+$/.match(line)[0])
        expect(result['AccessKey']).to eq('[FILTERED]')
        expect(result['Id']).not_to eq('[FILTERED]')
      end
      FileUtils.rm_f(log_file)
    end

  end
end
