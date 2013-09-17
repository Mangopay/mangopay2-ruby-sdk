require_relative '../../spec_helper'

describe MangoPay::AuthorizationToken do

  it 'uses StaticStorage strategy by default' do
    storage = MangoPay::AuthorizationToken::Manager.storage
    expect(storage).to be_kind_of MangoPay::AuthorizationToken::StaticStorage
  end

  it 'allows set different storage strategies' do

    # set to FileStorage
    file_storage = MangoPay::AuthorizationToken::FileStorage.new '.'
    MangoPay::AuthorizationToken::Manager.storage = file_storage
    storage = MangoPay::AuthorizationToken::Manager.storage
    expect(storage).to be file_storage

    # reset to StaticStorage
    static_storage = MangoPay::AuthorizationToken::StaticStorage.new
    MangoPay::AuthorizationToken::Manager.storage = static_storage
    storage = MangoPay::AuthorizationToken::Manager.storage
    expect(storage).to be static_storage

  end

  it 'shares tokens between calls' do
    users1 = MangoPay::User.fetch()
    token1 = MangoPay::AuthorizationToken::Manager.get_token
    users2 = MangoPay::User.fetch()
    token2 = MangoPay::AuthorizationToken::Manager.get_token
    expect(token1).to be token2
  end

end
