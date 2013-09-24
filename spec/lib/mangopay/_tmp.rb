require_relative '../../spec_helper'

describe '0' do
  include_context 'users'
  it '1' do
    MangoPay::User.fetch({page:1, per_page:2})
  end
end
