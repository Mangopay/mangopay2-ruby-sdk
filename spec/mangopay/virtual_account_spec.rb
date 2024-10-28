describe MangoPay::VirtualAccount do
  include_context 'virtual_account'
  include_context 'wallets'

  describe 'CREATE' do
    it 'can create a Virtual Account' do
      wallet = new_wallet
      virtual_account = new_virtual_account(wallet['Id'])
      expect(virtual_account).not_to be_nil
    end
  end

  describe 'DEACTIVATE' do
    it 'deactivates a Virtual Account' do
      wallet = new_wallet
      virtual_account = new_virtual_account(wallet['Id'])
      deactivated = MangoPay::VirtualAccount.deactivate(wallet['Id'], virtual_account['Id'])
      expect(deactivated).not_to be_nil
      expect(deactivated['Status']).to eq 'CLOSED'
      expect(deactivated['Id']).to eq(virtual_account['Id'])
    end
  end

  describe 'FETCH' do
    it 'can get a Virtual Account' do
      wallet = new_wallet
      virtual_account = new_virtual_account(wallet['Id'])
      fetched = MangoPay::VirtualAccount.fetch(wallet['Id'], virtual_account['Id'])
      expect(fetched).not_to be_nil
      expect(fetched['Id']).to eq(virtual_account['Id'])
    end
  end

  describe 'FETCH ALL' do
    it 'can get all Virtual Accounts for a wallet' do
      wallet = new_wallet
      virtual_account = new_virtual_account(wallet['Id'])
      fetched_list = MangoPay::VirtualAccount.fetch_all(wallet['Id'])
      expect(fetched_list).not_to be_nil
      expect(fetched_list[0]['Id']).to eq(virtual_account['Id'])
    end
  end

  describe 'FETCH AVAILABILITIES' do
    it 'get availabilities' do
      availabilities = MangoPay::VirtualAccount.fetch_availabilities
      expect(availabilities).not_to be_nil
      expect(availabilities['Collection']).not_to be_nil
      expect(availabilities['UserOwned']).not_to be_nil
    end
  end
end
