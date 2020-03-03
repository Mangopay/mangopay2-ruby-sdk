require_relative 'wallet_context'
require_relative 'card_context'
require_relative 'pre_authorization_context'
require_relative 'mandate_context'
require_relative '../../lib/mangopay/api/service/pay_ins'
require_relative '../../lib/mangopay/model/enum/card_type'
require_relative '../../lib/mangopay/model/enum/direct_debit_type'
require_relative '../../lib/mangopay/model/entity/pay_in/card_web_pay_in'
require_relative '../../lib/mangopay/model/entity/pay_in/card_direct_pay_in'
require_relative '../../lib/mangopay/model/entity/pay_in/card_pre_authorized_pay_in'
require_relative '../../lib/mangopay/model/entity/pay_in/bank_wire_direct_pay_in'
require_relative '../../lib/mangopay/model/entity/pay_in/direct_debit_web_pay_in'
require_relative '../../lib/mangopay/model/entity/pay_in/direct_debit_direct_pay_in'
require_relative '../../lib/mangopay/common/template_url_options'

shared_context 'pay_in_context' do
  include_context 'wallet_context'
  include_context 'card_context'
  include_context 'pre_authorization_context'
  include_context 'mandate_context'

  CARD_WEB_PAY_IN_DATA ||= build_card_web_pay_in
  CARD_DIRECT_PAY_IN_DATA ||= build_card_direct_pay_in
  CARD_PRE_AUTH_PAY_IN_DATA ||= build_card_pre_auth_pay_in
  BANK_WIRE_DIRECT_PAY_IN_DATA ||= build_bank_wire_direct_pay_in
  DIRECT_DEBIT_WEB_PAY_IN_DATA ||= build_direct_debit_web_pay_in
  DIRECT_DEBIT_DIRECT_PAY_IN_DATA ||= build_direct_debit_direct_pay_in
  CARD_WEB_PAY_IN_PERSISTED ||= persist_card_web CARD_WEB_PAY_IN_DATA
  CARD_DIRECT_PAY_IN_PERSISTED ||= persist_card_direct CARD_DIRECT_PAY_IN_DATA
  CARD_PRE_AUTH_PAY_IN_PERSISTED ||= persist_card_pre_auth CARD_PRE_AUTH_PAY_IN_DATA
  BANK_WIRE_DIRECT_PAY_IN_PERSISTED ||= persist_bank_wire_direct BANK_WIRE_DIRECT_PAY_IN_DATA
  DIRECT_DEBIT_WEB_PAY_IN_PERSISTED ||= persist_direct_debit_web DIRECT_DEBIT_WEB_PAY_IN_DATA
  DIRECT_DEBIT_DIRECT_PAY_IN_PERSISTED ||= persist_direct_debit_direct DIRECT_DEBIT_DIRECT_PAY_IN_DATA
end

def persist_card_web(pay_in)
  MangoApi::PayIns.create_card_web pay_in
end

def persist_card_direct(pay_in)
  MangoApi::PayIns.create_card_direct pay_in
end

def persist_card_pre_auth(pay_in)
  MangoApi::PayIns.create_card_pre_authorized pay_in
end

def persist_bank_wire_direct(pay_in)
  MangoApi::PayIns.create_bank_wire_direct pay_in
end

def persist_direct_debit_web(pay_in)
  MangoApi::PayIns.create_direct_debit_web pay_in
end

def persist_direct_debit_direct(pay_in)
  MangoApi::PayIns.create_direct_debit_direct pay_in
end

def build_card_web_pay_in
  pay_in = MangoModel::CardWebPayIn.new
  pay_in.author_id = NATURAL_USER_PERSISTED.id
  pay_in.credited_user_id = NATURAL_USER_PERSISTED.id
  pay_in.debited_funds = MangoModel::Money.new
  pay_in.debited_funds.currency = MangoModel::CurrencyIso::EUR
  pay_in.debited_funds.amount = 120
  pay_in.fees = MangoModel::Money.new
  pay_in.fees.currency = MangoModel::CurrencyIso::EUR
  pay_in.fees.amount = 30
  pay_in.return_url = 'http://www.my-site.com/returnURL/'
  pay_in.credited_wallet_id = WALLET_PERSISTED.id
  pay_in.card_type = MangoModel::CardType::CB_VISA_MASTERCARD
  pay_in.secure_mode = MangoModel::SecureMode::DEFAULT
  pay_in.culture = MangoModel::CultureCode::EN
  pay_in.template_url_options = TemplateUrlOptions.new
  pay_in.template_url_options.payline = 'https://www.mysite.com/template/'
  pay_in.statement_descriptor = 'Mar2016'
  pay_in
end

def build_card_direct_pay_in
  pay_in = MangoModel::CardDirectPayIn.new
  pay_in.author_id = NATURAL_USER_PERSISTED.id
  pay_in.credited_user_id = NATURAL_USER_PERSISTED.id
  pay_in.credited_wallet_id = WALLET_PERSISTED.id
  pay_in.debited_funds = MangoModel::Money.new
  pay_in.debited_funds.currency = MangoModel::CurrencyIso::EUR
  pay_in.debited_funds.amount = 120
  pay_in.fees = MangoModel::Money.new
  pay_in.fees.currency = MangoModel::CurrencyIso::EUR
  pay_in.fees.amount = 30
  pay_in.secure_mode_return_url = 'http://www.my-site.com/returnURL/'
  pay_in.card_id = CARD.id
  pay_in.secure_mode = MangoModel::SecureMode::DEFAULT
  pay_in.statement_descriptor = 'Mar2016'
  billing = MangoModel::Billing.new
  billing.address = build_address
  billing.address.postal_code = '68400'
  pay_in.billing = billing
  pay_in.culture = MangoModel::CultureCode::FR
  pay_in
end

def build_card_pre_auth_pay_in
  pay_in = MangoModel::CardPreAuthorizedPayIn.new
  pay_in.author_id = NATURAL_USER_PERSISTED.id
  pay_in.credited_user_id = NATURAL_USER_PERSISTED.id
  pay_in.credited_wallet_id = WALLET_PERSISTED.id
  pay_in.debited_funds = MangoModel::Money.new
  pay_in.debited_funds.currency = MangoModel::CurrencyIso::EUR
  pay_in.debited_funds.amount = 120
  pay_in.fees = MangoModel::Money.new
  pay_in.fees.currency = MangoModel::CurrencyIso::EUR
  pay_in.fees.amount = 30
  pay_in.preauthorization_id = PRE_AUTHORIZATION_PERSISTED.id
  pay_in.culture = MangoModel::CultureCode::FR
  pay_in
end

def build_bank_wire_direct_pay_in
  pay_in = MangoModel::BankWireDirectPayIn.new
  pay_in.author_id = NATURAL_USER_PERSISTED.id
  pay_in.credited_user_id = NATURAL_USER_PERSISTED.id
  pay_in.credited_wallet_id = WALLET_PERSISTED.id
  pay_in.declared_debited_funds = MangoModel::Money.new
  pay_in.declared_debited_funds.currency = MangoModel::CurrencyIso::EUR
  pay_in.declared_debited_funds.amount = 120
  pay_in.declared_fees = MangoModel::Money.new
  pay_in.declared_fees.currency = MangoModel::CurrencyIso::EUR
  pay_in.declared_fees.amount = 80
  pay_in.culture = MangoModel::CultureCode::FR
  pay_in
end

def build_direct_debit_web_pay_in
  pay_in = MangoModel::DirectDebitWebPayIn.new
  pay_in.author_id = NATURAL_USER_PERSISTED.id
  pay_in.credited_user_id = NATURAL_USER_PERSISTED.id
  pay_in.credited_wallet_id = WALLET_PERSISTED.id
  pay_in.debited_funds = MangoModel::Money.new
  pay_in.debited_funds.currency = MangoModel::CurrencyIso::EUR
  pay_in.debited_funds.amount = 10000
  pay_in.fees = MangoModel::Money.new
  pay_in.fees.currency = MangoModel::CurrencyIso::EUR
  pay_in.fees.amount = 100
  pay_in.return_url = 'http://www.my-site.com/returnURL/'
  pay_in.direct_debit_type = MangoModel::DirectDebitType::GIROPAY
  pay_in.secure_mode = MangoModel::SecureMode::DEFAULT
  pay_in.culture = MangoModel::CultureCode::EN
  pay_in.template_url_options = TemplateUrlOptions.new
  pay_in.template_url_options.payline = 'https://www.mysite.com/template/'
  pay_in
end

def build_direct_debit_direct_pay_in
  pay_in = MangoModel::DirectDebitDirectPayIn.new
  pay_in.author_id = NATURAL_USER_PERSISTED.id
  pay_in.credited_user_id = NATURAL_USER_PERSISTED.id
  pay_in.credited_wallet_id = WALLET_PERSISTED.id
  pay_in.debited_funds = MangoModel::Money.new
  pay_in.debited_funds.currency = MangoModel::CurrencyIso::EUR
  pay_in.debited_funds.amount = 10000
  pay_in.fees = MangoModel::Money.new
  pay_in.fees.currency = MangoModel::CurrencyIso::EUR
  pay_in.fees.amount = 100
  pay_in.mandate_id = MANDATE_PERSISTED.id
  pay_in.culture = MangoModel::CultureCode::FR
  pay_in
end

def its_the_same_card_web(pay_in1, pay_in2)
  pay_in1.author_id == pay_in2.author_id\
     && pay_in1.credited_user_id == pay_in2.credited_user_id\
     && its_the_same_money(pay_in1.debited_funds, pay_in2.debited_funds)\
     && its_the_same_money(pay_in1.fees, pay_in2.fees)\
     && pay_in1.credited_wallet_id == pay_in2.credited_wallet_id\
     && pay_in1.card_type.eql?(pay_in2.card_type)\
     && pay_in1.secure_mode.eql?(pay_in2.secure_mode)\
     && pay_in1.culture.eql?(pay_in2.culture)\
     && pay_in1.statement_descriptor == pay_in2.statement_descriptor
end

def its_the_same_card_direct(pay_in1, pay_in2)
  pay_in1.author_id == pay_in2.author_id\
     && pay_in1.credited_user_id == pay_in2.credited_user_id\
     && its_the_same_money(pay_in1.debited_funds, pay_in2.debited_funds)\
     && its_the_same_money(pay_in1.fees, pay_in2.fees)\
     && pay_in1.card_id == pay_in2.card_id\
     && pay_in1.secure_mode.eql?(pay_in2.secure_mode)\
     && pay_in1.statement_descriptor == pay_in2.statement_descriptor
end

def its_the_same_card_pre_auth(pay_in1, pay_in2)
  pay_in1.author_id == pay_in2.author_id\
     && pay_in1.credited_user_id == pay_in2.credited_user_id\
     && its_the_same_money(pay_in1.debited_funds, pay_in2.debited_funds)\
     && its_the_same_money(pay_in1.fees, pay_in2.fees)\
     && pay_in1.preauthorization_id == pay_in2.preauthorization_id
end

def its_the_same_bank_wire_direct(pay_in1, pay_in2)
  pay_in1.author_id == pay_in2.author_id\
     && pay_in1.credited_user_id == pay_in2.credited_user_id\
     && pay_in1.credited_wallet_id == pay_in2.credited_wallet_id\
     && its_the_same_money(pay_in1.declared_debited_funds, pay_in2.declared_debited_funds)\
     && its_the_same_money(pay_in1.declared_fees, pay_in2.declared_fees)
end

def its_the_same_direct_debit_web(pay_in1, pay_in2)
  pay_in1.author_id == pay_in2.author_id\
     && pay_in1.credited_user_id == pay_in2.credited_user_id\
     && its_the_same_money(pay_in1.debited_funds, pay_in2.debited_funds)\
     && its_the_same_money(pay_in1.fees, pay_in2.fees)\
     && pay_in1.credited_wallet_id == pay_in2.credited_wallet_id\
     && pay_in1.direct_debit_type.eql?(pay_in2.direct_debit_type)\
     && pay_in1.culture.eql?(pay_in2.culture)
end

def its_the_same_direct_debit_direct(pay_in1, pay_in2)
  pay_in1.author_id == pay_in2.author_id\
     && pay_in1.credited_user_id == pay_in2.credited_user_id\
     && pay_in1.credited_wallet_id == pay_in2.credited_wallet_id\
     && its_the_same_money(pay_in1.debited_funds, pay_in2.debited_funds)\
     && its_the_same_money(pay_in1.fees, pay_in2.fees)\
     && pay_in1.mandate_id == pay_in2.mandate_id\
     && pay_in1.statement_descriptor == pay_in2.statement_descriptor
end

def its_the_same_money(money1, money2)
  money1.currency.eql?(money2.currency)\
     && money1.amount == money2.amount
end