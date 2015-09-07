describe MangoPay::BankAccount do
  include_context 'bank_accounts'
  
  def create(params)
    user = new_natural_user
    params_fixed = { OwnerName: 'John', OwnerAddress: user['Address'] }.merge(params)
    MangoPay::BankAccount.create(user['Id'], params_fixed)
  end

  describe 'CREATE' do

    it 'creates a new IBAN bank detail' do
      expect(new_bank_account['Id']).not_to be_nil
    end

    it 'creates a new GB bank detail' do
      created = create({
        Type: 'GB',
        AccountNumber: '63956474',
        SortCode: '200000',
      })
      expect(created['Id']).not_to be_nil
      expect(created['Type']).to eq('GB')
      expect(created['AccountNumber']).to eq('63956474')
      expect(created['SortCode']).to eq('200000')
    end

    it 'creates a new US bank detail' do
      created = create({
        Type: 'US',
        AccountNumber: '234234234234',
        ABA: '234334789',
      })
      expect(created['Id']).not_to be_nil
      expect(created['Type']).to eq('US')
      expect(created['AccountNumber']).to eq('234234234234')
      expect(created['ABA']).to eq('234334789')
    end

    it 'creates a new CA bank detail' do
      created = create({
        Type: 'CA',
        BankName: 'TestBankName',
        BranchCode: '12345',
        AccountNumber: '234234234234',
        InstitutionNumber: '123',
      })
      expect(created['Id']).not_to be_nil
      expect(created['Type']).to eq('CA')
      expect(created['BankName']).to eq('TestBankName')
      expect(created['BranchCode']).to eq('12345')
      expect(created['AccountNumber']).to eq('234234234234')
      expect(created['InstitutionNumber']).to eq('123')
    end

    it 'creates a new OTHER bank detail' do
      created = create({
        Type: 'OTHER',
        Country: 'FR',
        AccountNumber: '234234234234',
        BIC: 'BINAADADXXX',
      })
      expect(created['Id']).not_to be_nil
      expect(created['Type']).to eq('OTHER')
      expect(created['Country']).to eq('FR')
      expect(created['AccountNumber']).to eq('234234234234')
      expect(created['BIC']).to eq('BINAADADXXX')
    end

  end

  describe 'FETCH' do

    it 'fetches all the bank details' do
      list = MangoPay::BankAccount.fetch(new_bank_account['UserId'])
      expect(list).to be_kind_of(Array)
      expect(list[0]['Id']).to eq(new_bank_account['Id'])
    end

    it 'fetches single bank detail' do
      single = MangoPay::BankAccount.fetch(new_bank_account['UserId'], new_bank_account['Id'])
      expect(single['Id']).to eq(new_bank_account['Id'])
    end
  end
end
