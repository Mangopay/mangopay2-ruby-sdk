require_relative '../../spec_helper'

describe MangoPay::Client do
  include_context 'clients'

  describe 'CREATE' do
    it 'creates a new client' do
      expect(new_client['ClientId']).to eq(client_id)
      expect(new_client['Email']).not_to be_nil
      expect(new_client['Passphrase']).not_to be_nil
    end

    it 'refuses the client id' do
      expect { wrong_client['errors'] }.to raise_error { |err|
        err.should be_a MangoPay::ResponseError
        err.type.should eq 'param_error'
      }
    end

    it "ClientId_already_exist" do
      expect {
        MangoPay::Client.create({
          'ClientId' => new_client['ClientId'],
          'Name' => 'What a nice name',
          'Email' => 'clientemail@email.com'
        })
      }.to raise_error MangoPay::ResponseError
    end
  end
end
