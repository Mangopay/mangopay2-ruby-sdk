require_relative '../../spec_helper'

describe MangoPay::PayIn::Card::Web, type: :feature do
  include_context 'users'
  include_context 'wallets'
  include_context 'cards'

  describe 'CREATE' do
    it 'creates a card' do
      expect(new_web_card['Id']).not_to be_nil
      expect(new_web_card['Status']).to eq('SUCCEEDED')
    end
  end

  describe 'FETCH' do
    it 'fetches a payin' do
      payin = MangoPay::PayIn.fetch(new_web_card['Id'])
      expect(payin['Id']).to eq(new_web_card['Id'])
    end
  end

  describe 'REFUND' do
    it 'refunds a payin' do
      payin_refund = MangoPay::PayIn.refund(new_web_card['Id'], {
        AuthorId: new_web_card['AuthorId']
      })
      expect(payin_refund['Id']).not_to be_nil
      expect(payin_refund['Status']).to eq('SUCCEEDED')
    end
  end
end
