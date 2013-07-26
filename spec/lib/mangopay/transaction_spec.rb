require_relative '../../spec_helper'

describe MangoPay::Transaction do
  include_context 'users'
  include_context 'wallets'

  describe 'FETCH' do
    it 'fetches the an empty list of transactions' do
      transactions = MangoPay::Transaction.fetch(new_wallet['Id'])
      expect(transactions).to be_kind_of(Array)
      expect(transactions).to be_empty
    end
  end
end
