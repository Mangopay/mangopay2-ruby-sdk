describe MangoPay::BankingAliasesIBAN do
  include_context 'bankigaliases'

  describe 'FETCH' do
    it 'fetches a banking alias' do
      bankingaliases = MangoPay::BankingAliasesIBAN.fetch(new_banking_alias['Id'])
      expect(bankingaliases['Id']).to eq(new_banking_alias['Id'])
    end
  end
end
