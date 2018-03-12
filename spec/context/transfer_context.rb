require_relative 'user_context'
require_relative 'wallet_context'
require_relative '../../lib/mangopay/model/entity/transfer'
require_relative '../../lib/mangopay/model/entity/transaction'
require_relative '../../lib/mangopay/model/money'
require_relative '../../lib/mangopay/api/service/transfers'

shared_context 'transfer_context' do
  include_context 'user_context'
  include_context 'wallet_context'

  TRANSFER_DATA ||= build_transfer
  TRANSFER_PERSISTED ||= persist_transfer TRANSFER_DATA

  let(:new_transfer_persisted) { persist_transfer TRANSFER_DATA }
end

def persist_transfer(transfer)
  MangoApi::Transfers.create transfer
end

# noinspection RubyResolve
def build_transfer
  transfer = MangoModel::Transfer.new
  transfer.author_id = NATURAL_USER_PERSISTED.id
  debited_funds = MangoModel::Money.new
  debited_funds.currency = MangoModel::CurrencyIso::EUR
  debited_funds.amount = 120
  transfer.debited_funds = debited_funds
  fees = MangoModel::Money.new
  fees.currency = MangoModel::CurrencyIso::EUR
  fees.amount = 20
  transfer.fees = fees
  transfer.debited_wallet_id = persist_wallet(WALLET_DATA).id
  transfer.credited_wallet_id = WALLET_PERSISTED.id
  transfer
end

def its_the_same_transfer(transfer1, transfer2)
  transfer1.author_id == transfer2.author_id\
    && transfer1.author_id == transfer2.author_id\
    && its_the_same_money(transfer1.debited_funds, transfer2.debited_funds)\
    && its_the_same_money(transfer1.fees, transfer2.fees)\
    && transfer1.debited_wallet_id == transfer2.debited_wallet_id\
    && transfer1.credited_wallet_id == transfer2.credited_wallet_id
end

def its_the_same_money(money1, money2)
  money1.currency.eql?(money2.currency)\
    && money1.amount == money2.amount
end