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

    it 'creates an intent report' do
      params = {
        "DownloadFormat": "CSV",
        "ReportType": "ECHO_INTENT",
        "AfterDate": 1748782023,
        "BeforeDate": 1753102013,
        "Filters": {
          "PaymentMethod": "PAYPAL",
          "Status": "CAPTURED",
          "Type": "PAYIN"
        },
        "Columns": %w[Id Status Amount Currency FeesAmount FeesCurrency Type PaymentMethod BuyerId SellerId]
      }

      created = MangoPay::ReportV2.create(params)
      expect(created['Id']).to_not be_nil
      expect(created['Status']).to eq("PENDING")
      expect(created['ReportType']).to eq("ECHO_INTENT")
    end

    it 'creates an intent actions report' do
      params = {
        "DownloadFormat": "CSV",
        "ReportType": "ECHO_INTENT_ACTION",
        "AfterDate": 1748782023,
        "BeforeDate": 1753102013,
        "Filters": {
          "PaymentMethod": "PAYPAL",
          "Status": "CAPTURED",
          "Type": "PAYIN"
        },
        "Columns": %w[IntentId Id ExternalProcessingDate ExternalProviderReference ExternalMerchantReference Status Amount Currency FeesAmount FeesCurrency Type PaymentMethod BuyerId SellerId]
      }

      created = MangoPay::ReportV2.create(params)
      expect(created['Id']).to_not be_nil
      expect(created['Status']).to eq("PENDING")
      expect(created['ReportType']).to eq("ECHO_INTENT_ACTION")
    end

    it 'creates settlement report' do
      params = {
        "Tag": "Creating a report using new Mangopay system",
        "DownloadFormat": "CSV",
        "ReportType": "ECHO_SETTLEMENT",
        "AfterDate": 1748782023,
        "BeforeDate": 1753102013,
        "Filters": {
          "Status": "RECONCILED",
          "ExternalProviderName": "PAYPAL"
        },
        "Columns": %w[Id CreationDate FileName SettlementCurrency Status SettledTransactionCount UnsettledTransactionCount SettledAmount DeclaredAmount DeficitAmount]
      }

      created = MangoPay::ReportV2.create(params)
      expect(created['Id']).to_not be_nil
      expect(created['Status']).to eq("PENDING")
      expect(created['ReportType']).to eq("ECHO_SETTLEMENT")
    end
  end

  it 'creates split report' do
    params = {
      "Tag": "Creating a report using new Mangopay system",
      "DownloadFormat": "CSV",
      "ReportType": "ECHO_SPLIT",
      "AfterDate": 1748782023,
      "BeforeDate": 1753102013,
      "Filters": {
        "Status": "COMPLETED",
        "IntentId": "int_0197f975-63f6-714e-8fc6-4451e128170f",
        "Scheduled": false
      },
      "Columns": %w[Id IntentId AuthorId Amount Currency FeesAmount FeesCurrency Status Description CreditedWalletId DebitedWalletId Scheduled CreationDate ExecutionDate]
    }

    created = MangoPay::ReportV2.create(params)
    expect(created['Id']).to_not be_nil
    expect(created['Status']).to eq("PENDING")
    expect(created['ReportType']).to eq("ECHO_SPLIT")
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
