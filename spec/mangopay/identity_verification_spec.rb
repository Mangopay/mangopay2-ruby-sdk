describe MangoPay::IdentityVerification do
  include_context 'users'

  let(:identity_verification) { nil }

  describe 'CREATE' do
    it 'creates a new identity verification' do
      created = create_new_identity_verification
      expect(created).not_to be_nil
      expect(created['HostedUrl']).not_to be_nil
      expect(created['ReturnUrl']).not_to be_nil
      expect(created['Status']).to eq('PENDING')
    end
  end

  def create_new_identity_verification
    user = new_natural_user
    if identity_verification == nil
      identity_verification = MangoPay::IdentityVerification.create(
        {
          ReturnUrl: 'http://example.com',
          Tag: 'created by the Ruby SDK'
        },
        user['Id']
      )
    end
    return identity_verification
  end

end