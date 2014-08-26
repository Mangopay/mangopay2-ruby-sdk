describe MangoPay::AuthorizationToken do

  _default_static_storage = MangoPay::AuthorizationToken::Manager.storage
  _new_file_storage = MangoPay::AuthorizationToken::FileStorage.new

  it 'uses StaticStorage strategy by default' do
    storage = _default_static_storage
    expect(storage).to be_kind_of MangoPay::AuthorizationToken::StaticStorage
  end

  it 'allows set different storage strategies' do

    # set to FileStorage
    file_storage = _new_file_storage
    MangoPay::AuthorizationToken::Manager.storage = file_storage
    storage = MangoPay::AuthorizationToken::Manager.storage
    expect(storage).to be file_storage

    # reset to StaticStorage
    static_storage = _default_static_storage
    MangoPay::AuthorizationToken::Manager.storage = static_storage
    storage = MangoPay::AuthorizationToken::Manager.storage
    expect(storage).to be static_storage
  end

  describe MangoPay::AuthorizationToken::StaticStorage do
    it 'shares tokens between calls' do
      MangoPay::AuthorizationToken::Manager.storage = _default_static_storage
      users1 = MangoPay::User.fetch
      token1 = MangoPay::AuthorizationToken::Manager.get_token
      users2 = MangoPay::User.fetch
      token2 = MangoPay::AuthorizationToken::Manager.get_token
      expect(token1).to eq token2
      expect(token1).to be token2 # moreover, it's the same instance
    end
  end

  describe MangoPay::AuthorizationToken::FileStorage do
    it 'shares tokens between calls' do
      MangoPay::AuthorizationToken::Manager.storage = _new_file_storage

      users1 = MangoPay::User.fetch
      token1 = MangoPay::AuthorizationToken::Manager.get_token
      users2 = MangoPay::User.fetch
      token2 = MangoPay::AuthorizationToken::Manager.get_token
      expect(token1).to eq token2
      expect(token1).not_to be token2 # it's NOT the same instance

      MangoPay::AuthorizationToken::Manager.storage = _default_static_storage # cleanup
    end

    it 'uses temp file with serialized token' do
      MangoPay::AuthorizationToken::Manager.storage = _new_file_storage

      file_path = _new_file_storage.file_path
      dir_path = MangoPay.configuration.temp_dir
      expect(file_path.start_with? dir_path).to be(true)

      token = MangoPay::AuthorizationToken::Manager.get_token
      expect(File.exists? file_path).to be(true)

      f = File.open(file_path, File::RDONLY)
      txt = f.read
      f.close
      expect(txt.include? token['access_token']).to be(true)

      MangoPay::AuthorizationToken::Manager.storage = _default_static_storage # cleanup
    end
  end
end
