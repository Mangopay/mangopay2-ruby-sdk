require_relative 'repudiation_context'
require_relative 'user_context'
require_relative '../../lib/mangopay/api/service/settlement_transfers'
require_relative '../../lib/mangopay/model/entity/settlement_transfer'

shared_context 'settlement_transfer_context' do
  include_context 'repudiation_context'
  include_context 'user_context'

  SETTLEMENT_TRANSFER_DATA ||= build_settlement_transfer
  SETTLEMENT_TRANSFER_PERSISTED ||= persist_transfer SETTLEMENT_TRANSFER_DATA
end

def persist_transfer(transfer)
  MangoApi::SettlementTransfers.create(REPUDIATION_PERSISTED.id, transfer)
end

def build_settlement_transfer
  transfer = MangoModel::SettlementTransfer.new
  transfer.author_id = REPUDIATION_PERSISTED.author_id
  transfer.debited_funds = MangoModel::Money.new
  transfer.debited_funds.currency = MangoModel::CurrencyIso::EUR
  transfer.debited_funds.amount = 120
  transfer.fees = MangoModel::Money.new
  transfer.fees.currency = MangoModel::CurrencyIso::EUR
  transfer.fees.amount = 0
  transfer
end