describe MangoPay::ReportV2 do

  def create
    params = {
      "Tag": "Created using the Mangopay API Postman collection",
      "DownloadFormat": "CSV",
      "ReportType": "COLLECTED_FEES",
      "AfterDate": 1740787200,
      "BeforeDate": 1743544740
    }
    MangoPay::ReportV2.create(params)
  end

  describe 'CREATE' do
    it 'creates a report v2' do
      created = create
      expect(created['Id']).to_not be_nil
      expect(created['Status']).to eq("PENDING")
    end
  end

  describe 'GET' do

    it 'gets a report' do
      created = create
      fetched = MangoPay::ReportV2.get(created['Id'])
      expect(fetched['Id']).to eq(created['Id'])
    end

    it 'gets all the reports' do
      reports = MangoPay::ReportV2.get_all
      expect(reports).to be_kind_of(Array)
      expect(reports).not_to be_empty
    end

  end

end
