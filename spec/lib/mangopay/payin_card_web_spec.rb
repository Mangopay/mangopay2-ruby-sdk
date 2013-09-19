require_relative '../../spec_helper'

describe MangoPay::PayIn::Card::Web, type: :feature do
  include_context 'users'
  include_context 'wallets'
  include_context 'payins'

  def check_type_and_status(payin)
    expect(payin['Type']).to eq('PAYIN')
    expect(payin['Nature']).to eq('REGULAR')
    expect(payin['PaymentType']).to eq('CARD')
    expect(payin['ExecutionType']).to eq('WEB')

    # not SUCCEEDED yet: waiting for processing
    expect(payin['Status']).to eq('CREATED')
    expect(payin['ResultCode']).to be_nil
    expect(payin['ResultMessage']).to be_nil
    expect(payin['ExecutionDate']).to be_nil
  end
  
  describe 'CREATE' do
    it 'creates a card web payin' do
      created = new_payin_card_web
      expect(created['Id']).not_to be_nil
      check_type_and_status(created)
    end
  end

  describe 'FETCH' do
    it 'fetches a payin' do
      created = new_payin_card_web
      fetched = MangoPay::PayIn.fetch(created['Id'])
      expect(fetched['Id']).to eq(created['Id'])
      expect(fetched['CreationDate']).to eq(created['CreationDate'])
      expect(fetched['CreditedFunds']).to eq(created['CreditedFunds'])
      expect(fetched['CreditedWalletId']).to eq(created['CreditedWalletId'])
      check_type_and_status(created)
    end
  end

  describe 'REFUND' do
    it 'refunds a payin' do
      payin = new_payin_card_web
      error = MangoPay::PayIn.refund(payin['Id'], {
        AuthorId: payin['AuthorId']
      })
      expect(error['Message']).to eq("Impossible to refund the transaction, can't have negative amount.")
    end
  end

end
