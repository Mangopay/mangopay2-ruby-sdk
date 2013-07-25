require_relative '../../spec_helper'

describe MangoPay::PayOut::BankWire do
  include_context 'users'
  include_context 'wallets'
  include_context 'bank_details'
  include_context 'bank_wires'

  describe 'CREATE' do
    it 'creates a bank wire payout' do
      expect(new_bank_wire['Message']).to be_nil
      expect(new_bank_wire['Id']).not_to be_nil
    end
  end

  describe 'FETCH' do
    it 'fetches a payout' do
      bank_wire = MangoPay::PayOut.fetch(new_bank_wire['Id'])
      expect(bank_wire['Id']).to eq(new_bank_wire['Id'])
    end
  end
end
