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
        expect(err).to be_a MangoPay::ResponseError
        expect(err.type).to eq 'param_error'
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

  describe 'FETCH' do
    it 'fetches the current client details' do
      clnt = MangoPay::Client.fetch
      expect(clnt['ClientId']).to eq(MangoPay.configuration.client_id)
    end
  end

  describe 'UPDATE' do
    it 'updates the current client details' do
      clnt = MangoPay::Client.fetch
      before = clnt['PrimaryThemeColour']
      after = before == '#aaaaaa' ? '#bbbbbb' : '#aaaaaa' # change the color
      clnt['PrimaryThemeColour'] = after

      updated = MangoPay::Client.update(clnt)
      expect(updated['ClientId']).to eq(MangoPay.configuration.client_id)
      expect(updated['PrimaryThemeColour']).to eq(after)
    end
  end

  describe 'UPLOAD LOGO' do
    it 'accepts Base64 encoded file content' do
      fnm = __FILE__.sub('.rb', '.png')
      bts = File.open(fnm, 'rb') { |f| f.read }
      b64 = Base64.encode64(bts)
      ret = MangoPay::Client.upload_logo(b64)
      expect(ret).to be_nil
    end

    it 'accepts file path' do
      fnm = __FILE__.sub('.rb', '.png')
      ret = MangoPay::Client.upload_logo(nil, fnm)
      expect(ret).to be_nil
    end

    it 'fails when input string is not base64-encoded' do
      file = 'any file content...'
      expect { MangoPay::Client.upload_logo(file) }.to raise_error { |err|
        expect(err).to be_a MangoPay::ResponseError
        expect(err.code).to eq '400'
        expect(err.type).to eq 'param_error'
      }
    end
  end

end
