describe MangoPay::PayOut::BankWire, type: :feature do
  include_context 'bank_accounts'
  include_context 'payins'
  include_context 'payouts'

  def check_type_and_status(payout, check_status = true)
    expect(payout['Type']).to eq('PAYOUT')
    expect(payout['Nature']).to eq('REGULAR')
    expect(payout['PaymentType']).to eq('BANK_WIRE')

    # linked to correct bank account
    expect(payout['BankAccountId']).to eq(new_bank_account['Id'])

    if (check_status)
      # not SUCCEEDED yet: waiting for processing
      expect(payout['ExecutionDate']).to be_nil
      expect(payout['Status']).to eq('CREATED')
      expect(payout['ResultCode']).to be_nil
      expect(payout['ResultMessage']).to be_nil
    end
  end

  describe 'CREATE' do

    it 'creates a bank wire payout' do
      payin = new_payin_card_direct # this payin is successfull so payout may happen
      payout = create_new_payout_bankwire(payin)
      expect(payout['Id']).not_to be_nil
      check_type_and_status(payout)
      expect(payout['DebitedWalletId']).to eq(payin['CreditedWalletId'])
    end

    it 'fails if not enough money' do
      payin = new_payin_card_web # this payin is NOT processed yet so payout may NOT happen
      payout = create_new_payout_bankwire(payin, 10000)
      sleep(2)
      fetched = MangoPay::PayOut::BankWire.get_bankwire(payout['Id'])
      check_type_and_status(payout, true)
      expect(fetched['Status']).to eq('FAILED')
      expect(fetched['ResultCode']).to eq('001001')
      expect(fetched['ResultMessage']).to eq('Unsufficient wallet balance')
    end
  end

  describe 'Get Bankwire' do
    it 'gets a bankwire' do
      created = new_payout_bankwire
      fetched = MangoPay::PayOut::BankWire.get_bankwire(created['Id'])
      expect(fetched['Id']).to eq(created['Id'])
      expect(fetched['CreationDate']).to eq(created['CreationDate'])
    end
  end

  describe 'Check Eligibility' do
    it 'checks the eligibility of a payout' do
      created = new_payout_bankwire

      eligibility = MangoPay::PayOut::InstantPayoutEligibility::Reachability.create(
        AuthorId: created['AuthorId'],
        DebitedFunds: {
          Amount: 10,
          Currency: 'EUR'
        },
        PayoutModeRequested: 'INSTANT_PAYMENT',
        BankAccountId: created['BankAccountId'],
        DebitedWalletId: created['DebitedWalletId']
      )

      expect(created).not_to be_nil
      expect(eligibility).not_to be_nil
    end
  end

  describe 'FETCH' do
    it 'fetches a payout' do
      created = new_payout_bankwire
      fetched = MangoPay::PayOut.fetch(created['Id'])
      expect(fetched['Id']).to eq(created['Id'])
      expect(fetched['CreationDate']).to eq(created['CreationDate'])
      check_type_and_status(created)
      check_type_and_status(fetched)
    end
  end

  describe 'GET Refunds' do
    it "fetches the pay-out's refunds" do
      payout = new_payout_bankwire
      refunds = MangoPay::PayOut.refunds(payout['Id'])
      expect(refunds).to be_an(Array)
    end
  end

end
