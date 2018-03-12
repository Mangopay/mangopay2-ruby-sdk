require_relative 'user_context'
require_relative 'card_context'
require_relative '../../lib/mangopay/model/entity/wallet'
require_relative '../../lib/mangopay/model/entity/pay_in/card_direct_pay_in'
require_relative '../../lib/mangopay/api/service/wallets'
require_relative '../../lib/mangopay/api/service/pay_ins'

shared_context 'wallet_context' do
  include_context 'user_context'
  include_context 'card_context'

  WALLET_DATA ||= build_wallet
  WALLET_PERSISTED ||= persist_wallet WALLET_DATA

  let(:new_wallet_persisted) { persist_wallet WALLET_DATA }
end

def persist_wallet(wallet)
  created = MangoApi::Wallets.create wallet
  pay_in = MangoModel::CardDirectPayIn.new
  pay_in.author_id = NATURAL_USER_PERSISTED.id
  pay_in.credited_user_id = NATURAL_USER_PERSISTED.id
  pay_in.credited_wallet_id = created.id
  pay_in.debited_funds = MangoModel::Money.new
  pay_in.debited_funds.currency = MangoModel::CurrencyIso::EUR
  pay_in.debited_funds.amount = 10_000
  pay_in.fees = MangoModel::Money.new
  pay_in.fees.currency = MangoModel::CurrencyIso::EUR
  pay_in.fees.amount = 30
  pay_in.secure_mode_return_url = 'http://www.my-site.com/returnURL/'
  pay_in.card_id = CARD.id
  pay_in.secure_mode = MangoModel::SecureMode::DEFAULT
  pay_in.statement_descriptor = 'Mar2016'
  MangoApi::PayIns.create_card_direct pay_in
  created
end

def build_wallet
  wallet = MangoModel::Wallet.new
  wallet.owners = [NATURAL_USER_PERSISTED.id]
  wallet.description = 'Just a wallet'
  wallet.currency = MangoModel::CurrencyIso::EUR
  wallet
end

def its_the_same_wallet(wallet1, wallet2)
  return false unless wallet1.owners.length == wallet2.owners.length
  wallet1.owners.each do |owner_id|
    return false unless wallet2.owners.include? owner_id
  end
  wallet1.description == wallet2.description\
    && wallet1.currency.eql?(wallet2.currency)
end