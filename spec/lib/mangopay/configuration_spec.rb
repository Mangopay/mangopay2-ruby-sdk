require_relative '../../spec_helper'

describe MangoPay::Configuration do

  it 'fails when calling with wrong client credentials' do
    c = MangoPay.configuration
    c.client_id = 'test_asd'
    c.client_passphrase = '00000'
    error = MangoPay::User.fetch()
    expect(error['Message']).not_to be_empty
    expect(['not_authorized', 'forbidden_ressource'].include? error['Type']).to be_true
  end

  it 'goes ok when calling with correct client credentials' do
    reset_mangopay_configuration
    users = MangoPay::User.fetch()
    expect(users).to be_kind_of(Array)
  end

end
