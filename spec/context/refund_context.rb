require_relative 'pay_in_context'
require_relative '../../lib/mangopay/model/entity/refund'

shared_context 'refund_context' do
  include_context 'pay_in_context'

  PAY_IN_REFUND_DATA ||= build_pay_in_refund
  PAY_IN_REFUND_PERSISTED ||= persist_refund PAY_IN_REFUND_DATA
  TRANSFER_REFUND_DATA ||= build_transfer_refund
  TRANSFER_REFUND_PERSISTED ||= persist_refund TRANSFER_REFUND_DATA
end

def persist_refund(refund)
  MangoApi::Refunds.create_for_pay_in(CARD_DIRECT_PAY_IN_PERSISTED.id, refund)
end

def build_pay_in_refund
  refund = MangoModel::Refund.new
  refund.author_id = NATURAL_USER_PERSISTED.id
  refund.debited_funds = MangoModel::Money.new
  refund.debited_funds.currency = MangoModel::CurrencyIso::EUR
  refund.debited_funds.amount = 20 + rand(30)
  refund.fees = MangoModel::Money.new
  refund.fees.currency = MangoModel::CurrencyIso::EUR
  refund.fees.amount = 5
  refund
end

def build_transfer_refund
  refund = MangoModel::Refund.new
  refund.author_id = NATURAL_USER_PERSISTED.id
  refund
end