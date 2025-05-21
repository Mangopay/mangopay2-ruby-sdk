describe MangoPay::Deposit do
  include_context 'users'
  include_context 'payins'

  describe 'CREATE' do
    it 'creates a new deposit' do
      author = new_natural_user
      card_registration = new_card_registration_completed
      deposit = create_new_deposit(card_registration['CardId'], author['Id'])

      assert_deposit(deposit, card_registration['CardId'], author["Id"])
    end
  end

  describe 'GET' do
    it 'get an existing deposit' do
      author = new_natural_user
      card_registration = new_card_registration_completed
      deposit = create_new_deposit(card_registration['CardId'], author['Id'])

      assert_deposit(deposit, card_registration['CardId'], author["Id"])

      fetched_deposit = MangoPay::Deposit.get(deposit['Id'])

      assert_deposit(fetched_deposit, card_registration['CardId'], author["Id"])
    end

    it 'gets all deposits for a user' do
      author = new_natural_user
      card_registration = new_card_registration_completed
      create_new_deposit(card_registration['CardId'], author['Id'])

      result = MangoPay::Deposit.get_all_for_user(author['Id'])
      expect(result).to be_kind_of(Array)
      expect(result.count).to be > 0
    end

    it 'gets all deposits for a card' do
      author = new_natural_user
      card_registration = new_card_registration_completed
      create_new_deposit(card_registration['CardId'], author['Id'])

      result = MangoPay::Deposit.get_all_for_card(card_registration['CardId'])
      expect(result).to be_kind_of(Array)
      expect(result.count).to be > 0
    end

    it 'fetches transactions for a deposit' do
      author = new_natural_user
      wallet = new_wallet
      card_registration = new_card_registration_completed
      deposit = create_new_deposit(card_registration['CardId'], author['Id'])
      create_new_payin_pre_authorized_deposit_direct(deposit['Id'], author['Id'], wallet['Id'])

      transactions = MangoPay::Deposit.get_transactions(deposit['Id'])
      expect(transactions).to be_kind_of(Array)
      expect(transactions.count).to be > 0
    end
  end

# the Cancel flow will be teste manually for now
=begin
  describe 'CANCEL' do
    it 'cancel an existing deposit' do
      author = new_natural_user
      card_registration = new_card_registration_completed
      deposit = create_new_deposit(card_registration['CardId'], author['Id'])

      assert_deposit(deposit, card_registration['CardId'], author["Id"])
      expect(deposit['Status']).to eq('CREATED')
      expect(deposit['PaymentStatus']).to eq('WAITING')

      MangoPay::Deposit.cancel(deposit['Id'])

      updated_deposit = MangoPay::Deposit.get(deposit['Id'])

      assert_deposit(updated_deposit, card_registration['CardId'], author["Id"])
      expect(updated_deposit['Status']).to eq('SUCCEEDED')
      expect(updated_deposit['PaymentStatus']).to eq('CANCELED')
    end
  end
=end
end


def assert_deposit(deposit, card_reg_id, author_id)
  expect(deposit['Id']).not_to be_nil
  expect(deposit['CreationDate']).not_to be_nil
  expect(deposit['ExpirationDate']).not_to be_nil
  expect(deposit['AuthorId']).not_to be_nil
  expect(deposit['DebitedFunds']).not_to be_nil
  expect(deposit['Status']).not_to be_nil
  expect(deposit['PaymentStatus']).not_to be_nil
  expect(deposit['PayinsLinked']).not_to be_nil
  expect(deposit['CardId']).not_to be_nil
  expect(deposit['CardId']).to eq(card_reg_id)
  expect(deposit['AuthorId']).to eq(author_id)
  expect(deposit['SecureModeReturnURL']).not_to be_nil
  expect(deposit['PaymentType']).not_to be_nil
  expect(deposit['ExecutionType']).not_to be_nil
  expect(deposit['StatementDescriptor']).not_to be_nil
  expect(deposit['Culture']).not_to be_nil
  expect(deposit['BrowserInfo']).not_to be_nil
  expect(deposit['IpAddress']).not_to be_nil
  expect(deposit['Billing']).not_to be_nil
  expect(deposit['Shipping']).not_to be_nil
end