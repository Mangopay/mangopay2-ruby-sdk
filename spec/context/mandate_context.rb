require_relative 'bank_account_context'
require_relative '../../lib/mangopay/model/enum/mandate_culture_code'
require_relative '../../lib/mangopay/api/service/mandates'

shared_context 'mandate_context' do
  include_context 'bank_account_context'

  MANDATE_DATA ||= build_mandate
  MANDATE_PERSISTED ||= persist_mandate MANDATE_DATA
end

def persist_mandate(mandate)
  MangoApi::Mandates.create mandate
end

def build_mandate
  mandate = MangoModel::Mandate.new
  mandate.bank_account_id = IBAN_ACCOUNT_PERSISTED.id
  mandate.culture = MangoModel::MandateCultureCode::EN
  mandate.return_url = 'http://www.my-site.com/returnURL/'
  mandate
end

def its_the_same_mandate(mandate1, mandate2)
  mandate1.bank_account_id == mandate2.bank_account_id\
    && mandate1.culture.eql?(mandate2.culture)
end