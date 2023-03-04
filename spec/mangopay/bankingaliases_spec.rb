describe MangoPay::BankingAliases do
  include_context 'users'
  include_context 'wallets'
  include_context 'bankingaliases'

  describe 'CREATE' do
    it 'creates a new banking alias' do
      expect(new_banking_alias['CreditedUserId']).to eq(new_natural_user['Id'])
    end
  end

  describe 'UPDATE' do
    it 'updates a banking alias' do
      updated_banking_alias = MangoPay::BankingAliases.update(new_banking_alias['Id'] ,{
          Active: false
      })
      expect(updated_banking_alias['Active']).to eq(false)
    end
  end

  describe 'FETCH' do
    it 'fetches all the banking aliases for a wallet' do
      bankingaliases = MangoPay::BankingAliases.fetch_for_wallet(new_banking_alias['WalletId'])
      expect(bankingaliases).to be_kind_of(Array)
      expect(bankingaliases).not_to be_empty
    end
  end

end