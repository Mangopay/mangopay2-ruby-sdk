describe MangoPay::Client do

  describe 'FETCH' do
    it 'fetches the current client details' do
      clnt = MangoPay::Client.fetch
      expect(clnt['ClientId']).to eq(MangoPay.configuration.client_id)
    end
  end

  describe 'FETCH' do
    it "fetches the client headquarter's phone number" do
      client = MangoPay::Client.fetch
      expect(client['HeadquartersPhoneNumber']).to_not be_nil
    end
  end

  describe 'UPDATE' do
    it 'updates the current client details' do
      clnt = MangoPay::Client.fetch
      before = clnt['PrimaryThemeColour']
      after = before == '#aaaaaa' ? '#bbbbbb' : '#aaaaaa' # change the color
      clnt['PrimaryThemeColour'] = after
      clnt['HeadquartersAddress'] = {
          AddressLine1: 'Rue Dandelion, n. 17',
          City: 'Lyon',
          Country: 'FR',
          PostalCode: '150770'
      }
      clnt['TechEmails'] = ['support@mangopay.com']
      phoneNumber = rand(99999999).to_s
      clnt['HeadquartersPhoneNumber'] = phoneNumber

      updated = MangoPay::Client.update(clnt)
      expect(updated['ClientId']).to eq(MangoPay.configuration.client_id)
      expect(updated['PrimaryThemeColour']).to eq(after)
      expect(updated['HeadquartersPhoneNumber']).to eq(phoneNumber)
    end
  end

  describe 'UPLOAD LOGO' do
    it 'accepts Base64 encoded file content' do
      fnm = __FILE__.sub('.rb', '.png')
      bts = File.open(fnm, 'rb') {|f| f.read}
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
      expect {MangoPay::Client.upload_logo(file)}.to raise_error {|err|
        expect(err).to be_a MangoPay::ResponseError
        expect(err.code).to eq '400'
        expect(err.type).to eq 'param_error'
      }
    end
  end

  describe 'fetch_wallets' do
    it 'fetches all client wallets' do
      wlts = MangoPay::Client.fetch_wallets
      expect(wlts).to be_kind_of(Array)
      expect(wlts).not_to be_empty
    end

    it 'fetches all client fees wallets' do
      wlts = MangoPay::Client.fetch_wallets('fees')
      expect(wlts).to be_kind_of(Array)
      expect(wlts).not_to be_empty
      expect((wlts.map {|m| m['FundsType']}).uniq).to eq(['FEES'])
    end

    it 'fetches all client credit wallets' do
      wlts = MangoPay::Client.fetch_wallets('credit')
      expect(wlts).to be_kind_of(Array)
      expect(wlts).not_to be_empty
      expect((wlts.map {|m| m['FundsType']}).uniq).to eq(['CREDIT'])
    end
  end

  describe 'fetch_wallet' do
    it 'fetches one of client wallets by funds type (fees) and currency' do
      wlt = MangoPay::Client.fetch_wallet('fees', 'EUR')
      expect(wlt).to be_kind_of(Hash)
      expect(wlt['FundsType']).to eq('FEES')
      expect(wlt['Currency']).to eq('EUR')
    end

    it 'fetches one of client wallets by funds type (credit) and currency' do
      wlt = MangoPay::Client.fetch_wallet('credit', 'EUR')
      expect(wlt).to be_kind_of(Hash)
      expect(wlt['FundsType']).to eq('CREDIT')
      expect(wlt['Currency']).to eq('EUR')
    end
  end

  describe 'fetch_wallets_transactions' do
    it 'fetches transactions for all client wallets' do
      trns = MangoPay::Client.fetch_wallets_transactions
      expect(trns).to be_kind_of(Array)
      expect(trns).not_to be_empty
    end
  end

  describe 'fetch_wallets_transactions' do
    it 'fetches transactions of one of client wallets by funds type (fees) and currency' do
      trns = MangoPay::Client.fetch_wallet_transactions('fees', 'EUR')
      expect(trns).to be_kind_of(Array)
      expect(trns).not_to be_empty
      #expect((trns.map {|m| m['DebitedWalletId']}).uniq).to eq(['FEES_EUR'])
    end

    it 'fetches transactions of one of client wallets by funds type (credit) and currency' do
      trns = MangoPay::Client.fetch_wallet_transactions('credit', 'EUR')
      expect(trns).to be_kind_of(Array)
      expect(trns).not_to be_empty
      #expect((trns.map {|m| m['CreditedWalletId']}).uniq).to eq(['CREDIT_EUR'])
    end
  end

end
