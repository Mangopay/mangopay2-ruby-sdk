require_relative 'user_context'
require_relative 'card_context'
require_relative '../../lib/mangopay/api/service/pre_authorizations'

shared_context 'pre_authorization_context' do
  include_context 'user_context'
  include_context 'card_context'

  PRE_AUTHORIZATION_DATA ||= build_pre_authorization
  PRE_AUTHORIZATION_PERSISTED ||= persist_pre_authorization PRE_AUTHORIZATION_DATA

  let(:new_pre_authorization_persisted) { persist_pre_authorization PRE_AUTHORIZATION_DATA }
end

def persist_pre_authorization(pre_auth)
  MangoApi::PreAuthorizations.create pre_auth
end

def build_pre_authorization
  pre_auth = MangoModel::PreAuthorization.new
  pre_auth.author_id = NATURAL_USER_PERSISTED.id
  pre_auth.debited_funds = MangoModel::Money.new
  pre_auth.debited_funds.currency = MangoModel::CurrencyIso::EUR
  pre_auth.debited_funds.amount = 120
  pre_auth.secure_mode = MangoModel::SecureMode::DEFAULT
  pre_auth.card_id = CARD.id
  pre_auth.secure_mode_return_url = 'http://www.my-site.com/returnURL'
  billing = MangoModel::Billing.new
  billing.address = build_address
  billing.address.postal_code = '68400'
  billing.first_name = 'John'
  billing.last_name = 'Doe'
  pre_auth.billing = billing
  pre_auth
end

def its_the_same_pre_auth(pre_auth1, pre_auth2)
  pre_auth1.author_id == pre_auth2.author_id\
    && its_the_same_money(pre_auth1.debited_funds, pre_auth2.debited_funds)\
    && pre_auth1.secure_mode.eql?(pre_auth2.secure_mode)\
    && pre_auth1.card_id == pre_auth2.card_id
end

def its_the_same_money(money1, money2)
  money1.currency.eql?(money2.currency)\
    && money1.amount == money2.amount
end