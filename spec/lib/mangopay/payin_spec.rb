require_relative '../../spec_helper'

describe MangoPay::PayIn::Card::Web, type: :feature do
  include_context 'users'
  include_context 'wallets'
  include_context 'payin_card_web'

  describe 'CREATE' do
    it 'creates a card web payin' do
      expect(new_payin_card_web['Id']).not_to be_nil
      #expect(new_payin_card_web['Status']).to eq('SUCCEEDED') # cannot test yet
      expect(new_payin_card_web['Status']).to eq('CREATED')
    end
  end

  describe 'FETCH' do
    it 'fetches a payin' do
      payin = MangoPay::PayIn.fetch(new_payin_card_web['Id'])
      expect(payin['Id']).to eq(new_payin_card_web['Id'])
    end
  end

  describe 'REFUND' do
    it 'refunds a payin' do
      payin_refund = MangoPay::PayIn.refund(new_payin_card_web['Id'], {
        AuthorId: new_payin_card_web['AuthorId']
      })
      expect(payin_refund['Id']).not_to be_nil
      #expect(payin_refund['Status']).to eq('SUCCEEDED') # cannot test yet
      expect(payin_refund['Status']).to be_nil
    end
  end

end
