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

    it 'fetches all identity verifications for a user' do
      create_new_identity_verification
      user = new_natural_user
      fetched = MangoPay::IdentityVerification.get_all(user['Id'])

      expect(fetched).not_to be_nil
      expect(fetched).to be_kind_of(Array)
      expect(fetched).not_to be_empty
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