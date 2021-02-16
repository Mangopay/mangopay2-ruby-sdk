require_relative 'bank_account_context'
require_relative 'pay_in_context'
require_relative '../../lib/mangopay/api/service/pay_outs'
require_relative '../../lib/mangopay/model/entity/pay_out'

shared_context 'pay_out_context' do
  include_context 'bank_account_context'
  include_context 'pay_in_context'

  PAY_OUT_DATA ||= build_pay_out
  PAY_OUT_PERSISTED ||= persist_pay_out PAY_OUT_DATA
end

def persist_pay_out(pay_out)
  MangoApi::PayOuts.create pay_out
end

def build_pay_out
  pay_out = MangoModel::PayOut.new
  pay_out.author_id = NATURAL_USER_PERSISTED.id
  pay_out.debited_funds = MangoModel::Money.new
  pay_out.debited_funds.currency = MangoModel::CurrencyIso::EUR
  pay_out.debited_funds.amount = 10
  pay_out.fees = MangoModel::Money.new
  pay_out.fees.currency = MangoModel::CurrencyIso::EUR
  pay_out.fees.amount = 0
  pay_out.bank_account_id = IBAN_ACCOUNT_PERSISTED.id
  pay_out.debited_wallet_id = WALLET_PERSISTED.id
  pay_out.bank_wire_ref = 'Invoice 7282'
  pay_out.payout_mode_requested = 'STANDARD'
  pay_out
end

def its_the_same_pay_out(pay_out1, pay_out2)
  pay_out1.author_id == pay_out2.author_id\
    && its_the_same_money(pay_out1.debited_funds, pay_out2.debited_funds)\
    && its_the_same_money(pay_out1.fees, pay_out2.fees)\
    && pay_out1.bank_account_id == pay_out2.bank_account_id\
    && pay_out1.debited_wallet_id == pay_out2.debited_wallet_id\
    && pay_out1.bank_wire_ref == pay_out2.bank_wire_ref
end