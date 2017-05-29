describe MangoPay::Report do

  def create
    params = {
      Tag: 'custom meta',
      CallbackURL: 'http://www.my-site.com/callbackURL/',
      DownloadFormat: 'CSV',
      Sort: 'CreationDate:DESC',
      Preview: false,
      Filters: {},
      Columns: [ 'Id', 'CreationDate' ],
      ReportType: 'wallets'
    }
    MangoPay::Report.create(params)
  end

  describe 'CREATE' do
    it 'creates a report' do
      created = create
      expect(created['Id']).to_not be_nil
    end
  end

  describe 'FETCH' do

    it 'fetches a report' do
      created = create
      fetched = MangoPay::Report.fetch(created['Id'])
      expect(fetched['Id']).to eq(created['Id'])
    end

    it 'fetches all the reports' do
      reports = MangoPay::Report.fetch()
      expect(reports).to be_kind_of(Array)
      expect(reports).not_to be_empty
    end

  end

end
