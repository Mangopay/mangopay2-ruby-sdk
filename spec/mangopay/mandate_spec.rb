describe MangoPay::Mandate do
  include_context 'mandates'

  def check_status(mandate)
    expect(mandate['Status']).to eq('CREATED')
    expect(mandate['MandateType']).to eq('DIRECT_DEBIT')
    expect(mandate['ExecutionType']).to eq('WEB')
  end

  describe 'CREATE' do
    it 'creates a mandate' do
      mandate = new_mandate
      expect(mandate['Id']).to_not be_nil
      check_status(mandate)
    end
  end

  describe 'FETCH' do

    it 'fetches a mandate' do
      created = new_mandate
      fetched = MangoPay::Mandate.fetch(created['Id'])
      expect(fetched['Id']).to eq(created['Id'])
      expect(fetched['CreationDate']).to eq(created['CreationDate'])
      expect(fetched['UserId']).to eq(created['UserId'])
      expect(fetched['BankAccountId']).to eq(created['BankAccountId'])
      check_status(created)
      check_status(fetched)
    end

    it 'fetches (all) mandates' do
      created1 = create_new_mandate()
      created2 = create_new_mandate()
      fetched = MangoPay::Mandate.fetch({'per_page' => 2, 'sort' => 'CreationDate:desc'})

      expect(fetched).to be_kind_of(Array)
      expect(fetched.count).to eq 2 # exactly 2 as pagiantion requested

      # all 2 are at top as lastly created
      # but may share the same CreationDate
      # so the order between them is undetermined
      expect(fetched.map {|m| m['Id']}).to include(created1['Id'], created2['Id'])
    end

  end

  describe 'FETCH FOR USER AND BANK ACCOUNT' do

    it 'fetches mandates for user' do
      created1 = create_new_mandate()
      created2 = create_new_mandate()
      expect(created1['UserId']).to eq(created2['UserId']) # both for same user

      user_id = created1['UserId']
      fetched = MangoPay::Mandate.fetch_for_user(user_id, {'per_page' => 2, 'sort' => 'CreationDate:desc'})

      expect(fetched).to be_kind_of(Array)
      expect(fetched.count).to eq 2 # exactly 2 as pagiantion requested
      expect(fetched.map {|m| m['Id']}).to include(created1['Id'], created2['Id'])
      expect((fetched.map {|m| m['UserId']}).uniq).to eq([user_id])
    end

    it 'fetches mandates for user bank account' do
      created1 = create_new_mandate()
      created2 = create_new_mandate()
      expect(created1['UserId']).to eq(created2['UserId']) # both for same user
      expect(created1['BankAccountId']).to eq(created2['BankAccountId']) # both for same bank account

      user_id = created1['UserId']
      bank_acc_id = created1['BankAccountId']
      fetched = MangoPay::Mandate.fetch_for_user_bank_account(user_id, bank_acc_id, {'per_page' => 2, 'sort' => 'CreationDate:desc'})

      expect(fetched).to be_kind_of(Array)
      expect(fetched.count).to eq 2 # exactly 2 as pagiantion requested
      expect(fetched.map {|m| m['Id']}).to include(created1['Id'], created2['Id'])
      expect((fetched.map {|m| m['UserId']}).uniq).to eq([user_id])
    end

  end

  describe 'CANCEL' do
    it 'cancels a mandate' do
      created = new_mandate
      expect { MangoPay::Mandate.cancel(created['Id']) }.to raise_error { |err|
        expect(err).to be_a MangoPay::ResponseError
        expect(err.code).to eq '400'
        expect(err.type).to eq 'mandate_cannot_be_cancelled'
      }
    end
  end

end
