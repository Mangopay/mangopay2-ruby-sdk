describe MangoPay::PayIn::RecurringPayments, type: :feature do
  include_context 'wallets'
  include_context 'users'
  include_context 'payins'

  describe 'CREATE' do
    it 'creates a recurring payment' do
      #user = create_new_natural_user
      cardreg = new_card_registration_3dsecure_completed
      wallet = new_wallet
      recurring = MangoPay::PayIn::RecurringPayments::Recurring.create(
        AuthorId: new_natural_user['Id'],
        CardId: cardreg['CardId'],
        CreditedUserId: wallet['Owners'][0],
        CreditedWalletId: wallet['Id'],
        FirstTransactionDebitedFunds: {Currency: 'EUR', Amount: 10},
        FirstTransactionFees: {Currency: 'EUR', Amount: 1},
        Billing: {
          Address: {
            AddressLine1: 'AddressLine1',
            AddressLine2: 'AddressLine2',
            City: 'City',
            Region: 'Region',
            PostalCode: 'PostalCode',
            Country: 'FR'
          },
          FirstName: 'Joe',
          LastName: 'Blogs'
        },
        Shipping: {
          Address: {
            AddressLine1: 'AddressLine1',
            AddressLine2: 'AddressLine2',
            City: 'City',
            Region: 'Region',
            PostalCode: 'PostalCode',
            Country: 'FR'
          },
          FirstName: 'Joe',
          LastName: 'Blogs'
        }
      )
      expect(recurring).not_to be_nil
      #created = new_payin_card_direct
      #expect(created['Id']).not_to be_nil
      #expect(created['Requested3DSVersion']).not_to be_nil
      #check_type_and_status(created)
    end
  end
end