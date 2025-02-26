describe MangoPay::IdentityVerification do
  include_context 'users'

  describe 'CREATE' do
    it 'creates a new identity verification' do
      created = create_new_identity_verification
      expect(created).not_to be_nil
      expect(created['HostedUrl']).not_to be_nil
      expect(created['ReturnUrl']).not_to be_nil
      expect(created['Status']).to eq('PENDING')
    end
  end

  describe 'GET' do
    it 'fetches existing identity verification' do
      created = create_new_identity_verification
      fetched = MangoPay::IdentityVerification.get(created['Id'])

      expect(fetched).not_to be_nil
      expect(created['HostedUrl']).to eq(fetched['HostedUrl'])
      expect(created['ReturnUrl']).to eq(fetched['ReturnUrl'])
      expect(created['Status']).to eq(fetched['Status'])
    end
  end

  describe 'GET CHECKS' do
    it 'fetches checks for an existing identity verification' do
      created = create_new_identity_verification
      checks = MangoPay::IdentityVerification.get_checks(created['Id'])

      expect(checks).not_to be_nil
      expect(created['Id']).to eq(checks['SessionId'])
      expect(checks['Status']).not_to be_nil
      expect(checks['CreationDate']).not_to be_nil
      expect(checks['LastUpdate']).not_to be_nil
      expect(checks['Checks']).not_to be_nil
    end
  end

  def create_new_identity_verification
    user = new_natural_user
    return MangoPay::IdentityVerification.create(
      {
        ReturnUrl: 'http://example.com',
        Tag: 'created by the Ruby SDK'
      },
      user['Id']
    )
  end

end