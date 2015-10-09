describe MangoPay::Dispute do
  include_context 'users'
  include_context 'wallets'

  # IMPORTANT NOTE!
  # 
  # Due to the fact the disputes CANNOT be created on user's side,
  # a special approach in testing is needed. 
  # In order to get the tests below pass, a bunch of disputes have
  # to be prepared on the API server side - if they're not, you can
  # just skip these tests, as they won't pass.
  before(:all) do
    @disputes = MangoPay::Dispute.fetch({'per_page' => 30}) #TODO: 50? 100?????????????????????????????????????
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
      id = @disputes.first['Id']
      transactions = MangoPay::Dispute.transactions(id, {'per_page' => 1})
      expect(transactions).to be_kind_of(Array)
      expect(transactions).not_to be_empty
    end
  end

  describe 'FETCH FOR USER AND WALLET' do
    it 'fetches disputes for user' do
      id = @disputes.first['Id']
      transactions = MangoPay::Dispute.transactions(id, {'per_page' => 1})
      user_id = transactions[0]['AuthorId']
      disputes = MangoPay::Dispute.fetch_for_user(user_id, {'per_page' => 1})
      expect(disputes).to be_kind_of(Array)
      expect(disputes).not_to be_empty
    end
    it 'fetches disputes for wallet' do
      dispute = @disputes.find {|disp| disp['InitialTransactionId'] != nil}
      expect(dispute).not_to be_nil, "Cannot test fetching disputes for wallet because there's no disputes with transaction ID in the disputes list."
      payin = MangoPay::PayIn.fetch(dispute['InitialTransactionId'])
      wallet_id = payin['CreditedWalletId']
      disputes = MangoPay::Dispute.fetch_for_wallet(wallet_id, {'per_page' => 1})
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

  describe 'CLOSE' do
    it 'closes a dispute' do
      dispute = @disputes.find {|disp| ['PENDING_CLIENT_ACTION', 'REOPENED_PENDING_CLIENT_ACTION'].include? disp['Status']}
      expect(dispute).not_to be_nil, "Cannot test closing dispute because there's no available disputes with expected status in the disputes list."
      id = dispute['Id']
      changed_dispute = MangoPay::Dispute.close(id)
      expect(changed_dispute['Id']).to eq(id)
      expect(changed_dispute['Status']).to eq('CLOSED')
    end
  end

  describe 'CONTEST' do
    it 'contests a dispute' do
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
    end
  end

# TODO; TEMP COMMENTED-OUT: NO TEST DATA
#  describe 'RESUBMIT' do
#    it 'resubmits a dispute' do
#      dispute = @disputes.find do |disp|
#        ['REOPENED_PENDING_CLIENT_ACTION'].include?(disp['Status']) &&
#        ['CONTESTABLE', 'RETRIEVAL'].include?(disp['DisputeType'])
#      end
#      expect(dispute).not_to be_nil, "Cannot test resubmiting dispute because there's no available disputes with expected status in the disputes list."
#      id = dispute['Id']
#      changed_dispute = MangoPay::Dispute.resubmit(id)
#      expect(changed_dispute['Id']).to eq(id)
#      expect(changed_dispute['Status']).to eq('SUBMITTED')
#    end
#  end

  describe 'FETCH REPUDIATION' do
    it 'fetches a repudiation' do
      dispute = @disputes.find {|disp| disp['InitialTransactionId'] != nil}
      expect(dispute).not_to be_nil, "Cannot test closing dispute because there's no disputes with transaction ID in the disputes list."
      transactions = MangoPay::Dispute.transactions(dispute['Id'], {'per_page' => 1})
      repudiation_id = transactions[0]['Id']
      repudiation = MangoPay::Dispute.fetch_repudiation(repudiation_id)
      expect(repudiation['Id']).to eq(repudiation_id)
      expect(repudiation['Nature']).to eq('REPUDIATION')
    end
  end

  describe 'CREATE SETTLEMENT TRANSFER' do
    it 'creates settlement transfer' do
      dispute = @disputes.find {|disp| disp['Status'] == 'CLOSED'}
      expect(dispute).not_to be_nil, "Cannot test creating settlement transfer because there's no closed disputes in the disputes list."
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
    end
  end

end
