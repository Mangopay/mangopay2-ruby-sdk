require_relative '../../spec_helper'

describe MangoPay::PayOut::BankWire, type: :feature do
  include_context 'users'
  include_context 'wallets'
  include_context 'bank_details'
  include_context 'payin_card_web'
  include_context 'payout_bankwire'

  describe 'CREATE' do
    it 'fails cause not enough money' do
      expect(new_payout_bankwire['Message']).to eq("The amount you wish to spend must be smaller than the amount left in your collection.")
    end
  end
 
# cannot test yet:
#  describe 'CREATE' do
#    it 'creates a bank wire payout' do
#      expect(new_payout_bankwire['Id']).not_to be_nil
#      #expect(new_payout_bankwire['Status']).to eq('CREATED')
#      expect(new_payout_bankwire['Status']).to be_nil
#      "The amount you wish to spend must be smaller than the amount left in your collection."
#    end
#  end
#
#  describe 'FETCH' do
#    it 'fetches a payout' do
#      bank_wire = MangoPay::PayOut.fetch(new_payout_bankwire['Id'])
#      expect(bank_wire['Id']).to eq(new_payout_bankwire['Id'])
#      expect(new_payout_bankwire['Status']).to eq('CREATED')
#    end
#  end

end
