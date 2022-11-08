describe MangoPay::Deposit do
  include_context 'users'
  include_context 'payins'

  describe 'CREATE' do
    it 'creates a new deposit' do
      author = new_natural_user
      card_registration = new_card_registration_completed
      deposit = create_new_deposit(card_registration['Id'], author['Id'])

      assert_deposit(deposit, card_registration['CardId'], author["Id"])
    end
  end

  describe 'GET' do
    it 'get an existing deposit' do
      author = new_natural_user
      card_registration = new_card_registration_completed
      deposit = create_new_deposit(card_registration['Id'], author['Id'])

      assert_deposit(deposit, card_registration['CardId'], author["Id"])

      fetched_deposit = MangoPay::Deposit.get(deposit['Id'])

      assert_deposit(fetched_deposit, card_registration['CardId'], author["Id"])
    end
  end

  describe 'CANCEL' do
    it 'cancel an existing deposit' do
      author = new_natural_user
      card_registration = new_card_registration_completed
      deposit = create_new_deposit(card_registration['Id'], author['Id'])

      assert_deposit(deposit, card_registration['CardId'], author["Id"])
      expect(deposit['Status']).to eq('SUCCEEDED')
      expect(deposit['PaymentStatus']).to eq('WAITING')

      MangoPay::Deposit.cancel(deposit['Id'])

      updated_deposit = MangoPay::Deposit.get(deposit['Id'])

      assert_deposit(updated_deposit, card_registration['CardId'], author["Id"])
      expect(updated_deposit['Status']).to eq('SUCCEEDED')
      expect(updated_deposit['PaymentStatus']).to eq('CANCELED')
    end
  end
end


def assert_deposit(deposit, card_reg_id, author_id)
  expect(deposit['Id']).not_to be_nil
  expect(deposit['Id'].to_i).to be > 0
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
  expect(deposit['SecureModeRedirectURL']).not_to be_nil
  expect(deposit['PaymentType']).not_to be_nil
  expect(deposit['ExecutionType']).not_to be_nil
  expect(deposit['StatementDescriptor']).not_to be_nil
  expect(deposit['Culture']).not_to be_nil
  expect(deposit['BrowserInfo']).not_to be_nil
  expect(deposit['IpAddress']).not_to be_nil
  expect(deposit['Billing']).not_to be_nil
  expect(deposit['Shipping']).not_to be_nil
end