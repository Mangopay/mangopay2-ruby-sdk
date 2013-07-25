require_relative '../../spec_helper'

describe MangoPay::Client do
  include_context 'clients'

  describe 'CREATE' do
    it 'creates a new client' do
      expect(new_client['ClientID']).to eq(MangoPay.configuration.client_id)
      expect(new_client['Passphrase']).not_to be_nil
    end

    it "ClientID_already_exist" do
      expect(new_client['Type']).to eq('ClientID_already_exist')
      expect(new_client['Message']).to eq('A partner with this ClientID already exist')
    end
  end
end
