require_relative '../../spec_helper'

describe MangoPay::PayIn::Card::Web do
  include_context 'users'
  include_context 'wallets'
  include_context 'cards'

  describe 'CREATE' do
    it 'creates a card' do
      expect(new_web_card['RedirectURL']).not_to be_empty
    end
  end

  describe 'FETCH' do
    it 'fetches a payin' do
      payin = MangoPay::PayIn.fetch(new_web_card['Id'])
      expect(payin['Id']).to eq(new_web_card['Id'])
    end
  end
end
