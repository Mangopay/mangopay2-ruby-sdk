describe MangoPay::Settlement do

  let!(:settlement) do
    create_settlement_if_needed
  end

  def create_settlement_if_needed
    @settlement ||= begin
                      file_path = File.expand_path('settlement_sample.csv', __dir__)
                      file = File.binread(file_path)
                      MangoPay::Settlement.upload(file)
                    end
  end

  describe 'UPLOAD' do
    it 'uploads the file' do
      expect(@settlement['Status']).to eq('UPLOADED')
    end
  end

  describe 'GET' do
    it 'fetches the file' do
      fetched = MangoPay::Settlement.get(@settlement['SettlementId'])
      expect(fetched['Status']).to eq('UPLOADED')
    end
  end

  describe 'UPDATE' do
    it 'updates the file' do
      file_path = File.expand_path('settlement_sample.csv', __dir__)
      file = File.binread(file_path)
      before_update = MangoPay::Settlement.upload(file)
      expect(before_update['Status']).to eq('UPLOADED')
      updated = MangoPay::Settlement.update(before_update['SettlementId'], file)
      expect(updated['Status']).to eq('UPLOADED')
    end
  end
end
