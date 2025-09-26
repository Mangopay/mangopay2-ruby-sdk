describe MangoPay::Dispute do

=begin
comment out all Dispute related unit tests please
these require manual actions on our side
and it's infact not suitable like that

  # IMPORTANT NOTE!
  # 
  # Due to the fact the disputes CANNOT be created on user's side,
  # a special approach in testing is needed. 
  # In order to get the tests below pass, a bunch of disputes have
  # to be prepared on the API server side - if they're not, you can
  # just skip these tests, as they won't pass.
  before(:each) do
    @disputes = MangoPay::Dispute.fetch({'page' => 1, 'per_page' => 100})
  end

  describe 'FETCH' do
    it 'fetches disputes' do
      expect(@disputes).to be_kind_of(Array)
      expect(@disputes).not_to be_empty
    end
    it 'fetches a dispute' do
      id = @disputes.first['Id']
      dispute = MangoPay::Dispute.fetch(id)
      expect(dispute['Id']).to eq(id)
    end
  end

  describe 'TRANSACTIONS' do
    it 'fetches transactions for dispute' do
      dispute = @disputes.find { |d| d['DisputeType'] == 'NOT_CONTESTABLE' }
      id = dispute['Id']
      transactions = MangoPay::Dispute.transactions(id, {'per_page' => 1})
      expect(transactions).to be_kind_of(Array)
      expect(transactions).not_to be_empty
    end
  end

  describe 'FETCH FOR USER AND WALLET' do
    it 'fetches disputes for user' do
      dispute = @disputes.find { |d| d['DisputeType'] == 'NOT_CONTESTABLE' }
      id = dispute['Id']
      transactions = MangoPay::Dispute.transactions(id, {'per_page' => 1})
      user_id = transactions[0]['AuthorId']
      disputes = MangoPay::Dispute.fetch_for_user(user_id, {'per_page' => 1})
      expect(disputes).to be_kind_of(Array)
      expect(disputes).not_to be_empty
    end
    it 'fetches disputes for wallet' do
      payin = MangoPay::PayIn.fetch("133379281")
      wallet_id = payin['CreditedWalletId']
      disputes = MangoPay::Dispute.fetch_for_wallet(wallet_id, {'per_page' => 1})
      expect(disputes).to be_kind_of(Array)
      expect(disputes).not_to be_empty
    end
    it 'fetches disputes for payin' do
      disputes = MangoPay::Dispute.fetch_for_pay_in("133379281", {'per_page' => 1})
      expect(disputes).to be_kind_of(Array)
      expect(disputes).not_to be_empty
    end
  end

  describe 'UPDATE' do
    it 'updates a dispute' do
      dispute = @disputes.first
      id = dispute['Id']
      new_tag = dispute['Tag'] + '.com'
      changed_dispute = MangoPay::Dispute.update(id, {Tag: new_tag})
      expect(changed_dispute['Tag']).to eq(new_tag)
    end
  end

  describe 'FETCH REPUDIATION' do
    it 'fetches a repudiation' do
      dispute = @disputes.find {|disp| disp['InitialTransactionId'] != nil && disp['DisputeType'] == 'NOT_CONTESTABLE'}
      expect(dispute).not_to be_nil, "Cannot test closing dispute because there's no not contestable disputes with transaction ID in the disputes list."
      transactions = MangoPay::Dispute.transactions(dispute['Id'], {'per_page' => 1})
      repudiation_id = transactions[0]['Id']
      repudiation = MangoPay::Dispute.fetch_repudiation(repudiation_id)
      expect(repudiation['Id']).to eq(repudiation_id)
      expect(repudiation['Nature']).to eq('REPUDIATION')
    end
  end

  describe 'CREATE AND FETCH SETTLEMENT TRANSFER' do
    it 'creates and fetches settlement transfer' do
      dispute = @disputes.find {|disp| disp['Status'] == 'CLOSED' && disp['DisputeType'] == 'NOT_CONTESTABLE'}
      expect(dispute).not_to be_nil, "Cannot test creating settlement transfer because there's no closed, not contestable disputes in the disputes list."
      transactions = MangoPay::Dispute.transactions(dispute['Id'], {'per_page' => 1})
      repudiation_id = transactions[0]['Id']
      repudiation = MangoPay::Dispute.fetch_repudiation(repudiation_id)
      params = {
        AuthorId: repudiation['AuthorId'],
        DebitedFunds: {Currency: 'EUR', Amount: 1},
        Fees: {Currency: 'EUR', Amount: 0},
        Tag: 'Custom tag data'
      }

      transfer = MangoPay::Dispute.create_settlement_transfer(repudiation_id, params)
      expect(transfer['Type']).to eq('TRANSFER')
      expect(transfer['Nature']).to eq('SETTLEMENT')

      fetched_transfer = MangoPay::Dispute.fetch_settlement_transfer(transfer['Id'])
      expect(fetched_transfer['Id']).to eq(transfer['Id'])
      expect(fetched_transfer['CreationDate']).to eq(transfer['CreationDate'])
    end
  end

  # NOTE: This test has not been run. Please check it if you have the chance.
  describe 'GET DISPUTES PENDING SETTLEMENT' do
    it 'retrieves disputes awaiting settlement actions' do
      disputes_pending = MangoPay::Dispute.fetch_pending_settlement

      expect(disputes_pending).to be_kind_of Array
      disputes_pending.each do |dispute|
        expect(dispute['Id']).not_to be_nil
        # TODO: Maybe check for corresponding status
      end
    end
  end

  describe 'DISPUTE DOCUMENTS API' do

    def find_dispute
      dispute = @disputes.find {|disp| ['PENDING_CLIENT_ACTION', 'REOPENED_PENDING_CLIENT_ACTION'].include?(disp['Status'])}
      expect(dispute).not_to be_nil, "Cannot test dispute document API because there's no dispute with expected status in the disputes list."
      dispute
    end

    def create_doc(dispute = nil)
      no_dispute_passed = dispute.nil?
      dispute = find_dispute if no_dispute_passed
      params = { Type: 'DELIVERY_PROOF', Tag: 'Custom tag data' }
      doc = MangoPay::Dispute.create_document(dispute['Id'], params)
      doc['dispute'] = dispute if no_dispute_passed # add it for testing purposes
      doc
    end

    it 'creates dispute document' do
      doc = create_doc
      expect(doc['Type']).to eq('DELIVERY_PROOF')
      expect(doc['Tag']).to eq('Custom tag data')
      expect(doc['Status']).to eq('CREATED')
    end

    it 'fetches dispute document' do
      created_doc = create_doc
      fetched_doc = MangoPay::Dispute.fetch_document(created_doc['Id'])
      fields = ['Id', 'Type', 'Tag', 'Status', 'CreationDate', 'RefusedReasonType', 'RefusedReasonMessage']
      fields.each do |field|
        expect(fetched_doc[field]).to eq(created_doc[field])
      end
    end

    it 'updates dispute document' do
      created_doc = create_doc
      
      fnm = __FILE__.sub('.rb', '.png')
      ret = MangoPay::Dispute.create_document_page(created_doc['dispute']['Id'], created_doc['Id'], nil, fnm)
      
      changed_doc = MangoPay::Dispute.update_document(created_doc['dispute']['Id'], created_doc['Id'], {
        Status: 'VALIDATION_ASKED'
      })
      expect(changed_doc['Id']).to eq(created_doc['Id'])
      expect(changed_doc['Status']).to eq('VALIDATION_ASKED')
    end

    it 'fetches a list of documents' do
      disp = @disputes.find {|disp| disp['Status'] == 'SUBMITTED'}
      disp = test_contest_dispute if disp == nil
      expect(disp).not_to be_nil, "Cannot test fetching dispute documents because there's no dispute with expected status in the disputes list."

      doc1 = create_doc(disp)
      doc2 = create_doc(disp) # for the same dispute

      filters = {'per_page' => 2, 'sort' => 'CreationDate:desc'}

      # fetch last 2 docs for the dispute
      docs = MangoPay::Dispute.fetch_documents(disp['Id'], filters)
      expect(docs).to be_kind_of(Array)
      expect(docs.count).to eq 2 # exactly 2 as pagiantion requested
      # all 2 are at top as lastly created
      # but may share the same CreationDate
      # so the order between them is undetermined
      expect(docs).to include(doc1, doc2)

      # fetch all docs ever
      docs = MangoPay::Dispute.fetch_documents()
      expect(docs).to be_kind_of(Array)
      expect(docs.count).to be >= 2

      # fetch last 2 docs ever (sorting by date descending)
      docs = MangoPay::Dispute.fetch_documents(nil, filters)
      expect(docs).to be_kind_of(Array)
      expect(docs.count).to eq 2 # exactly 2 as pagiantion requested
      expect(docs).to include(doc1, doc2)
    end

    def create_doc_page(file)
      disp = find_dispute
      doc = create_doc(disp)
      MangoPay::Dispute.create_document_page(disp['Id'], doc['Id'], file)
    end

    it 'create_document_page accepts Base64 encoded file content' do
      fnm = __FILE__.sub('.rb', '.png')
      bts = File.open(fnm, 'rb') { |f| f.read }
      b64 = Base64.encode64(bts)
      ret = create_doc_page(b64)
      expect(ret).to be_nil
    end

    it 'create_document_page accepts file path' do
      fnm = __FILE__.sub('.rb', '.png')
      disp = find_dispute
      doc = create_doc(disp)
      ret = MangoPay::Dispute.create_document_page(disp['Id'], doc['Id'], nil, fnm)
      expect(ret).to be_nil
    end

    it 'create_document_page fails when input string is not base64-encoded' do
      file = 'any file content...'
      expect { create_doc_page(file) }.to raise_error { |err|
        expect(err).to be_a MangoPay::ResponseError
        expect(err.code).to eq '400'
        expect(err.type).to eq 'param_error'
      }
    end
  end

  # TODO: Run this test when possible
  it 'create_document_consult fetches a list of document page consults' do
    fnm = __FILE__.sub('.rb', '.png')
    disp = find_dispute
    doc = create_doc(disp)
    MangoPay::Dispute.create_document_page(disp['Id'], doc['Id'], nil, fnm)
    consults = MangoPay::Dispute.create_document_consult(doc['Id'])

    expect(consults).not_to be_nil
    expect(consults).to be_kind_of(Array)
  end

  def test_contest_dispute
      dispute = @disputes.find do |disp|
        ['PENDING_CLIENT_ACTION', 'REOPENED_PENDING_CLIENT_ACTION'].include?(disp['Status']) &&
        ['CONTESTABLE', 'RETRIEVAL'].include?(disp['DisputeType'])
      end
      expect(dispute).not_to be_nil, "Cannot test contesting dispute because there's no available disputes with expected status and type in the disputes list."
      id = dispute['Id']
      contested_funds = dispute['Status'] == 'PENDING_CLIENT_ACTION' ? { Amount: 10, Currency: 'EUR' } : nil;
      changed_dispute = MangoPay::Dispute.contest(id, contested_funds)
      expect(changed_dispute['Id']).to eq(id)
      expect(changed_dispute['Status']).to eq('SUBMITTED')
      changed_dispute
  end

  describe 'CONTEST' do
    it 'contests a dispute' do
      test_contest_dispute
    end
  end

  describe 'RESUBMIT' do
    it 'resubmits a dispute' do
      dispute = @disputes.find do |disp|
        ['REOPENED_PENDING_CLIENT_ACTION'].include?(disp['Status'])
      end
      expect(dispute).not_to be_nil, "Cannot test resubmiting dispute because there's no available disputes with expected status in the disputes list."
      id = dispute['Id']
      changed_dispute = MangoPay::Dispute.resubmit(id)
      expect(changed_dispute['Id']).to eq(id)
      expect(changed_dispute['Status']).to eq('SUBMITTED')
    end
  end

  describe 'CLOSE' do
    it 'closes a dispute' do
      dispute = @disputes.find do |disp|
        ['PENDING_CLIENT_ACTION', 'REOPENED_PENDING_CLIENT_ACTION'].include?(disp['Status']) &&
        ['CONTESTABLE', 'RETRIEVAL'].include?(disp['DisputeType'])
      end
      expect(dispute).not_to be_nil, "Cannot test closing dispute because there's no available disputes with expected status in the disputes list."
      id = dispute['Id']
      changed_dispute = MangoPay::Dispute.close(id)
      expect(changed_dispute['Id']).to eq(id)
      expect(changed_dispute['Status']).to eq('CLOSED')
    end
  end

=end
  describe 'create bankwire payin to repudiation wallet' do
    it 'creates a bankwire payin' do
      created_pay_in = described_class.create_bankwire_payin_to_repudiation_wallet('EUR', 1000)
      expect(created_pay_in['Id']).not_to be_nil
      expect(created_pay_in['CreditedWalletId']).to eq('CREDIT_EUR')
      expect(created_pay_in['DeclaredDebitedFunds']['Currency']).to eq('EUR')
      expect(created_pay_in['DeclaredDebitedFunds']['Amount']).to eq(1000)
      expect(created_pay_in['Type']).to eq('PAYIN')
      expect(created_pay_in['Nature']).to eq('REGULAR')
      expect(created_pay_in['PaymentType']).to eq('BANK_WIRE')
      expect(created_pay_in['ExecutionType']).to eq('DIRECT')
      expect(created_pay_in['Status']).to eq('CREATED')
      expect(created_pay_in['ResultCode']).to be_nil
      expect(created_pay_in['ResultMessage']).to be_nil
      expect(created_pay_in['ExecutionDate']).to be_nil
    end
  end
end
