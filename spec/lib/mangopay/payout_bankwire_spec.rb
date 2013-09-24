require_relative '../../spec_helper'

describe MangoPay::PayOut::BankWire, type: :feature do
  include_context 'bank_accounts'
  include_context 'payins'
  include_context 'payouts'

  def check_type_and_status(payout)
    expect(payout['Type']).to eq('PAYOUT')
    expect(payout['Nature']).to eq('REGULAR')
    expect(payout['PaymentType']).to eq('BANK_WIRE')

    # linked to correct bank account
    expect(payout['BankAccountId']).to eq(new_bank_account['Id'])

    # not SUCCEEDED yet: waiting for processing
    expect(payout['Status']).to eq('CREATED')
    expect(payout['ResultCode']).to be_nil
    expect(payout['ResultMessage']).to be_nil
    expect(payout['ExecutionDate']).to be_nil
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
      expect {
        create_new_payout_bankwire(payin)
      }.to raise_error { |err|
        err.should be_a MangoPay::ResponseError
        err.type.should eq 'other'
        err.message.should eq 'The amount you wish to spend must be smaller than the amount left in your collection.'
      }
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

end
