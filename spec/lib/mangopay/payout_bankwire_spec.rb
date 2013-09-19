require_relative '../../spec_helper'

describe MangoPay::PayOut::BankWire, type: :feature do
  include_context 'users'
  include_context 'wallets'
  include_context 'bank_details'
  include_context 'payins'

  def new_payout_bankwire(payin, bank_detail = nil)
    bank_detail ||= new_iban_bank_detail
    MangoPay::PayOut::BankWire.create({
      AuthorId: payin['CreditedUserId'],
      DebitedWalletId: payin['CreditedWalletId'],
      DebitedFunds: { Currency: 'EUR', Amount: 500 },
      Fees: { Currency: 'EUR', Amount: 0 },
      BankAccountId: bank_detail['Id'],
      Communication: 'This is a test',
      Tag: 'Test Bank Wire'
    })
  end

  describe 'CREATE' do
    it 'fails if not enough money' do
      err = new_payout_bankwire(new_payin_card_web)
      expect(err['Message']).to eq("The amount you wish to spend must be smaller than the amount left in your collection.")
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
