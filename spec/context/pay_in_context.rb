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
require_relative '../../lib/mangopay/model/entity/pay_in/bank_wire_external_instruction_pay_in'
require_relative '../../lib/mangopay/model/entity/pay_in/direct_debit_web_pay_in'
require_relative '../../lib/mangopay/model/entity/pay_in/direct_debit_direct_pay_in'
require_relative '../../lib/mangopay/model/entity/pay_in/apple_pay_direct_pay_in'
require_relative '../../lib/mangopay/model/entity/pay_in/paypal_web_pay_in'
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
  PAYPAL_PAY_IN_DATA ||= build_paypal_pay_in
  APPLE_PAY_PAY_IN_DATA ||= build_apple_pay_pay_in
  CARD_WEB_PAY_IN_PERSISTED ||= persist_card_web CARD_WEB_PAY_IN_DATA
  CARD_DIRECT_PAY_IN_PERSISTED ||= persist_card_direct CARD_DIRECT_PAY_IN_DATA
  CARD_PRE_AUTH_PAY_IN_PERSISTED ||= persist_card_pre_auth CARD_PRE_AUTH_PAY_IN_DATA
  BANK_WIRE_DIRECT_PAY_IN_PERSISTED ||= persist_bank_wire_direct BANK_WIRE_DIRECT_PAY_IN_DATA
  DIRECT_DEBIT_WEB_PAY_IN_PERSISTED ||= persist_direct_debit_web DIRECT_DEBIT_WEB_PAY_IN_DATA
  DIRECT_DEBIT_DIRECT_PAY_IN_PERSISTED ||= persist_direct_debit_direct DIRECT_DEBIT_DIRECT_PAY_IN_DATA
  PAYPAL_PAY_IN_PERSISTED ||= persist_paypal_web PAYPAL_PAY_IN_DATA
  APPLE_PAY_PAY_IN_PERSISTED ||= persis_apple_pay_direct APPLE_PAY_PAY_IN_DATA
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

def persist_paypal_web(pay_in)
  MangoApi::PayIns.create_paypal_web pay_in
end

def persis_apple_pay_direct(pay_in)
  MangoApi::PayIns.create_apple_pay_direct pay_in
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

def build_paypal_pay_in
  pay_in = MangoModel::PaypalWebPayIn.new
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
  pay_in.culture = MangoModel::CultureCode::FR
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

def build_apple_pay_pay_in
  pay_in = MangoModel::ApplePayPayIn.new
  pay_in.author_id = NATURAL_USER_PERSISTED.id
  pay_in.credited_user_id = NATURAL_USER_PERSISTED.id
  pay_in.credited_wallet_id = WALLET_PERSISTED.id
  pay_in.debited_funds = MangoModel::Money.new
  pay_in.debited_funds.currency = MangoModel::CurrencyIso::EUR
  pay_in.debited_funds.amount = 199
  pay_in.fees = MangoModel::Money.new
  pay_in.fees.currency = MangoModel::CurrencyIso::EUR
  pay_in.fees.amount = 1
  pay_in.return_url = 'http://www.my-site.com/returnURL/'
  pay_in.payment_data = {
      TransactionId: '061EB32181A2D9CA42AD16031B476EEBAA62A9A095AD660E2759FBA52B51A61',
      Network: 'VISA',
      TokenData: "{\"version\":\"EC_v1\",\"data\":\"w4HMBVqNC9ghPP4zncTA\\/0oQAsduERfsx78oxgniynNjZLANTL6+0koEtkQnW\\/K38Zew8qV1GLp+fLHo+qCBpiKCIwlz3eoFBTbZU+8pYcjaeIYBX9SOxcwxXsNGrGLk+kBUqnpiSIPaAG1E+WPT8R1kjOCnGvtdombvricwRTQkGjtovPfzZo8LzD3ZQJnHMsWJ8QYDLyr\\/ZN9gtLAtsBAMvwManwiaG3pOIWpyeOQOb01YcEVO16EZBjaY4x4C\\/oyFLWDuKGvhbJwZqWh1d1o9JT29QVmvy3Oq2JEjq3c3NutYut4rwDEP4owqI40Nb7mP2ebmdNgnYyWfPmkRfDCRHIWtbMC35IPg5313B1dgXZ2BmyZRXD5p+mr67vAk7iFfjEpu3GieFqwZrTl3\\/pI5V8Sxe3SIYKgT5Hr7ow==\",\"signature\":\"MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCAMIID5jCCA4ugAwIBAgIIaGD2mdnMpw8wCgYIKoZIzj0EAwIwejEuMCwGA1UEAwwlQXBwbGUgQXBwbGljYXRpb24gSW50ZWdyYXRpb24gQ0EgLSBHMzEmMCQGA1UECwwdQXBwbGUgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkxEzARBgNVBAoMCkFwcGxlIEluYy4xCzAJBgNVBAYTAlVTMB4XDTE2MDYwMzE4MTY0MFoXDTIxMDYwMjE4MTY0MFowYjEoMCYGA1UEAwwfZWNjLXNtcC1icm9rZXItc2lnbl9VQzQtU0FOREJPWDEUMBIGA1UECwwLaU9TIFN5c3RlbXMxEzARBgNVBAoMCkFwcGxlIEluYy4xCzAJBgNVBAYTAlVTMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEgjD9q8Oc914gLFDZm0US5jfiqQHdbLPgsc1LUmeY+M9OvegaJajCHkwz3c6OKpbC9q+hkwNFxOh6RCbOlRsSlaOCAhEwggINMEUGCCsGAQUFBwEBBDkwNzA1BggrBgEFBQcwAYYpaHR0cDovL29jc3AuYXBwbGUuY29tL29jc3AwNC1hcHBsZWFpY2EzMDIwHQYDVR0OBBYEFAIkMAua7u1GMZekplopnkJxghxFMAwGA1UdEwEB\\/wQCMAAwHwYDVR0jBBgwFoAUI\\/JJxE+T5O8n5sT2KGw\\/orv9LkswggEdBgNVHSAEggEUMIIBEDCCAQwGCSqGSIb3Y2QFATCB\\/jCBwwYIKwYBBQUHAgIwgbYMgbNSZWxpYW5jZSBvbiB0aGlzIGNlcnRpZmljYXRlIGJ5IGFueSBwYXJ0eSBhc3N1bWVzIGFjY2VwdGFuY2Ugb2YgdGhlIHRoZW4gYXBwbGljYWJsZSBzdGFuZGFyZCB0ZXJtcyBhbmQgY29uZGl0aW9ucyBvZiB1c2UsIGNlcnRpZmljYXRlIHBvbGljeSBhbmQgY2VydGlmaWNhdGlvbiBwcmFjdGljZSBzdGF0ZW1lbnRzLjA2BggrBgEFBQcCARYqaHR0cDovL3d3dy5hcHBsZS5jb20vY2VydGlmaWNhdGVhdXRob3JpdHkvMDQGA1UdHwQtMCswKaAnoCWGI2h0dHA6Ly9jcmwuYXBwbGUuY29tL2FwcGxlYWljYTMuY3JsMA4GA1UdDwEB\\/wQEAwIHgDAPBgkqhkiG92NkBh0EAgUAMAoGCCqGSM49BAMCA0kAMEYCIQDaHGOui+X2T44R6GVpN7m2nEcr6T6sMjOhZ5NuSo1egwIhAL1a+\\/hp88DKJ0sv3eT3FxWcs71xmbLKD\\/QJ3mWagrJNMIIC7jCCAnWgAwIBAgIISW0vvzqY2pcwCgYIKoZIzj0EAwIwZzEbMBkGA1UEAwwSQXBwbGUgUm9vdCBDQSAtIEczMSYwJAYDVQQLDB1BcHBsZSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTETMBEGA1UECgwKQXBwbGUgSW5jLjELMAkGA1UEBhMCVVMwHhcNMTQwNTA2MjM0NjMwWhcNMjkwNTA2MjM0NjMwWjB6MS4wLAYDVQQDDCVBcHBsZSBBcHBsaWNhdGlvbiBJbnRlZ3JhdGlvbiBDQSAtIEczMSYwJAYDVQQLDB1BcHBsZSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTETMBEGA1UECgwKQXBwbGUgSW5jLjELMAkGA1UEBhMCVVMwWTATBgcqhkjOPQIBBggqhkjOPQMBBwNCAATwFxGEGddkhdUaXiWBB3bogKLv3nuuTeCN\\/EuT4TNW1WZbNa4i0Jd2DSJOe7oI\\/XYXzojLdrtmcL7I6CmE\\/1RFo4H3MIH0MEYGCCsGAQUFBwEBBDowODA2BggrBgEFBQcwAYYqaHR0cDovL29jc3AuYXBwbGUuY29tL29jc3AwNC1hcHBsZXJvb3RjYWczMB0GA1UdDgQWBBQj8knET5Pk7yfmxPYobD+iu\\/0uSzAPBgNVHRMBAf8EBTADAQH\\/MB8GA1UdIwQYMBaAFLuw3qFYM4iapIqZ3r6966\\/ayySrMDcGA1UdHwQwMC4wLKAqoCiGJmh0dHA6Ly9jcmwuYXBwbGUuY29tL2FwcGxlcm9vdGNhZzMuY3JsMA4GA1UdDwEB\\/wQEAwIBBjAQBgoqhkiG92NkBgIOBAIFADAKBggqhkjOPQQDAgNnADBkAjA6z3KDURaZsYb7NcNWymK\\/9Bft2Q91TaKOvvGcgV5Ct4n4mPebWZ+Y1UENj53pwv4CMDIt1UQhsKMFd2xd8zg7kGf9F3wsIW2WT8ZyaYISb1T4en0bmcubCYkhYQaZDwmSHQAAMYIBizCCAYcCAQEwgYYwejEuMCwGA1UEAwwlQXBwbGUgQXBwbGljYXRpb24gSW50ZWdyYXRpb24gQ0EgLSBHMzEmMCQGA1UECwwdQXBwbGUgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkxEzARBgNVBAoMCkFwcGxlIEluYy4xCzAJBgNVBAYTAlVTAghoYPaZ2cynDzANBglghkgBZQMEAgEFAKCBlTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xOTA1MjMxMTA1MDdaMCoGCSqGSIb3DQEJNDEdMBswDQYJYIZIAWUDBAIBBQChCgYIKoZIzj0EAwIwLwYJKoZIhvcNAQkEMSIEIIvfGVQYBeOilcB7GNI8m8+FBVZ28QfA6BIXaggBja2PMAoGCCqGSM49BAMCBEYwRAIgU01yYfjlx9bvGeC5CU2RS5KBEG+15HH9tz\\/sg3qmQ14CID4F4ZJwAz+tXAUcAIzoMpYSnM8YBlnGJSTSp+LhspenAAAAAAAA\",\"header\":{\"ephemeralPublicKey\":\"MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAE0rs3wRpirXjPbFDQfPRdfEzRIZDWm0qn7Y0HB0PNzV1DDKfpYrnhRb4GEhBF\\/oEXBOe452PxbCnN1qAlqcSUWw==\",\"publicKeyHash\":\"saPRAqS7TZ4bAYwzBj8ezDDC55ZolyH1FL+Xc8fd93o=\",\"transactionId\":\"b061eb32181a2d9ca42ad16031b476eebaa62a9a095ad660e2759fba52b51a61\"}}"
  }
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

def its_the_same_paypal_web(pay_in1, pay_in2)
  pay_in1.author_id == pay_in2.author_id\
      && pay_in1.credited_user_id == pay_in2.credited_user_id\
      && its_the_same_money(pay_in1.debited_funds, pay_in2.debited_funds)\
      && its_the_same_money(pay_in1.fees, pay_in2.fees)\
      && pay_in1.credited_wallet_id == pay_in2.credited_wallet_id\
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

def its_the_same_apple_pay_direct(pay_in1, pay_in2)
  pay_in1.author_id == pay_in2.author_id\
      && pay_in1.credited_user_id == pay_in2.credited_user_id\
      && pay_in1.credited_wallet_id == pay_in2.credited_wallet_id\
      && its_the_same_money(pay_in1.debited_funds, pay_in2.debited_funds)\
      && its_the_same_money(pay_in1.fees, pay_in2.fees)
end

def its_the_same_money(money1, money2)
  money1.currency.eql?(money2.currency)\
      && money1.amount == money2.amount
end