describe MangoPay::Recipient do
  include_context 'recipient'

  describe 'CREATE' do
    it 'creates a new recipient' do
      recipient = new_recipient
      assert_recipient(recipient)
      expect(recipient['PendingUserAction']).not_to be_nil
    end
  end

  describe 'GET' do
    it 'fetches a recipient' do
      recipient = new_recipient
      fetched = MangoPay::Recipient.get(recipient['Id'])
      assert_recipient(fetched)
    end
  end

  describe 'GET User Recipients' do
    it 'fetches a recipient' do
      john = create_new_natural_user_sca_owner
      create_new_recipient(john['Id'])
      fetched = MangoPay::Recipient.get_user_recipients(john['Id'])
      expect(fetched).not_to be_nil
      expect(fetched).to be_kind_of(Array)
      expect(fetched).not_to be_empty
    end
  end

  describe 'GET Schema' do
    it 'fetches schema for LocalBankTransfer, Individual' do
      schema = MangoPay::Recipient.get_schema('LocalBankTransfer', 'Individual', 'GBP')
      expect(schema).not_to be_nil
      expect(schema['DisplayName']).not_to be_nil
      expect(schema['Currency']).not_to be_nil
      expect(schema['RecipientType']).not_to be_nil
      expect(schema['PayoutMethodType']).not_to be_nil
      expect(schema['RecipientScope']).not_to be_nil
      expect(schema['Tag']).not_to be_nil
      expect(schema['IndividualRecipient']).not_to be_nil
      expect(schema['LocalBankTransfer']).not_to be_nil
      expect(schema['BusinessRecipient']).to be_nil
      expect(schema['InternationalBankTransfer']).to be_nil
    end

    it 'fetches schema for InternationalBankTransfer, Business' do
      schema = MangoPay::Recipient.get_schema('InternationalBankTransfer', 'Business', 'GBP')
      expect(schema).not_to be_nil
      expect(schema['DisplayName']).not_to be_nil
      expect(schema['Currency']).not_to be_nil
      expect(schema['RecipientType']).not_to be_nil
      expect(schema['PayoutMethodType']).not_to be_nil
      expect(schema['RecipientScope']).not_to be_nil
      expect(schema['Tag']).not_to be_nil
      expect(schema['BusinessRecipient']).not_to be_nil
      expect(schema['InternationalBankTransfer']).not_to be_nil
      expect(schema['IndividualRecipient']).to be_nil
      expect(schema['LocalBankTransfer']).to be_nil
    end
  end

  describe 'GET Payout Methods' do
    it 'fetches payout methods' do
      payout_methods = MangoPay::Recipient.get_payout_methods('DE', 'EUR')
      expect(payout_methods).not_to be_nil
      expect(payout_methods['AvailablePayoutMethods']).to be_kind_of(Array)
      expect(payout_methods['AvailablePayoutMethods']).not_to be_empty
    end
  end

  describe 'VALIDATE' do
    it 'validates a recipient' do
      recipient = define_new_recipient
      john = create_new_natural_user_sca_owner
      # it should pass
      MangoPay::Recipient.validate(recipient, john['Id'])

      # it should throw error
      recipient['Currency'] = nil
      expect { MangoPay::Recipient.validate(recipient, john['Id']) }.to raise_error { |err|
        expect(err).to be_a MangoPay::ResponseError
        expect(err.code).to eq '400'
        expect(err.type).to eq 'param_error'
      }
    end
  end

  describe 'DEACTIVATE' do
    it 'deactivates a recipient' do
      # pending("a recipient needs to be manually activated before running the test")
      john = create_new_natural_user_sca_owner
      recipient = create_new_recipient(john['Id'])
      deactivated = MangoPay::Recipient.deactivate(recipient['Id'])
      fetched = MangoPay::Recipient.get(recipient['Id'])
      expect(deactivated['Status']).to eq('DEACTIVATED')
      expect(fetched['Status']).to eq('DEACTIVATED')
    end
  end
end


def assert_recipient(recipient)
  expect(recipient).not_to be_nil
  expect(recipient['Status']).not_to be_nil
  expect(recipient['DisplayName']).not_to be_nil
  expect(recipient['PayoutMethodType']).not_to be_nil
  expect(recipient['RecipientType']).not_to be_nil
  expect(recipient['IndividualRecipient']).not_to be_nil
  expect(recipient['LocalBankTransfer']).not_to be_nil
  expect(recipient['RecipientScope']).not_to be_nil
  expect(recipient['UserId']).not_to be_nil
end