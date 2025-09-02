describe MangoPay::PayIn::PayPal::Web, type: :feature do
  include_context 'payins'

  def check_type_and_status(payin)
    expect(payin['Type']).to eq('PAYIN')
    expect(payin['Nature']).to eq('REGULAR')
    expect(payin['PaymentType']).to eq('PAYPAL')
    expect(payin['ExecutionType']).to eq('WEB')

    # not SUCCEEDED yet: waiting for processing
    expect(payin['Status']).to eq('CREATED')
    expect(payin['ResultCode']).to be_nil
    expect(payin['ResultMessage']).to be_nil
    expect(payin['ExecutionDate']).to be_nil
  end

  describe 'CREATE' do
    it 'creates a paypal web payin' do
      created = new_payin_paypal_web
      expect(created['Id']).not_to be_nil
      check_type_and_status(created)
    end
  end

  describe 'CREATE V2' do
    it 'creates a paypal web v2 payin' do
      created = new_payin_paypal_web_v2
      expect(created['Id']).not_to be_nil
      # generic operation error
      # check_type_and_status(created)
    end
  end

  describe "FETCH" do
    it 'FETCHES a payIn with PayPal account email' do
      pending("Expired PayIn id")
      payin_id = "54088959"
      buyer_account_email = "paypal-buyer-user@mangopay.com"
      payin = MangoPay::PayIn.fetch(id = payin_id)

      expect(payin).not_to be_nil
      expect(payin["PaypalBuyerAccountEmail"]).not_to be_nil
      expect(payin["PaypalBuyerAccountEmail"]).to eq(buyer_account_email)
    end
  end

  describe 'FETCH' do
    it 'fetches a payin' do
      created = new_payin_paypal_web
      fetched = MangoPay::PayIn.fetch(created['Id'])
      expect(fetched['Id']).to eq(created['Id'])
      expect(fetched['CreationDate']).to eq(created['CreationDate'])
      expect(fetched['CreditedFunds']).to eq(created['CreditedFunds'])
      expect(fetched['CreditedWalletId']).to eq(created['CreditedWalletId'])
      check_type_and_status(created)
      check_type_and_status(fetched)
    end
  end

  # skip because of Generic Operation Error
  describe 'FETCH V2' do
    xit 'fetches a payin' do
      created = new_payin_paypal_web_v2
      fetched = MangoPay::PayIn.fetch(created['Id'])
      expect(fetched['Id']).to eq(created['Id'])
      expect(fetched['CreationDate']).to eq(created['CreationDate'])
      expect(fetched['CreditedFunds']).to eq(created['CreditedFunds'])
      expect(fetched['CreditedWalletId']).to eq(created['CreditedWalletId'])
      check_type_and_status(created)
      check_type_and_status(fetched)
    end
  end

end
