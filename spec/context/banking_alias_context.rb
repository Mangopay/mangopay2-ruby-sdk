require_relative '../../lib/mangopay/api/service/banking_aliases'
require_relative '../../lib/mangopay/model/entity/banking_alias'
require_relative 'wallet_context'

shared_context 'banking_alias_context' do
  include_context 'wallet_context'
  BANKING_ALIAS ||= build_banking_alis
end

def build_banking_alis
  banking_alias = MangoModel::BankingAlias.new
  banking_alias.country = 'LU'
  banking_alias.tag = "Tag test"
  banking_alias.owner_name = 'John Doe'
  banking_alias.credited_user_id = nil
  banking_alias
end