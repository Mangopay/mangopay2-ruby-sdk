require_relative 'user_context'
require_relative '../../lib/mangopay/model/entity/ubo_declaration'
require_relative '../../lib/mangopay/api/service/ubo_declarations'
require_relative '../../lib/mangopay/model/entity/ubo'
require_relative '../../lib/mangopay/model/enum/natural_user_capacity'
require_relative 'birthplace_context'

shared_context 'ubo_declaration_context' do
  include_context 'user_context'
  include_context 'birthplace_context'
end

def persist_ubo_declaration(user_id)
  MangoApi::UboDeclarations.create(user_id)
end

def persist_ubo(user_id, ubo_declaration_id)
  MangoApi::UboDeclarations.create_ubo(user_id, ubo_declaration_id, build_ubo)
end

def build_ubo
  ubo = MangoModel::Ubo.new
  ubo.first_name = "First"
  ubo.last_name = "Last"
  ubo.address = build_address
  ubo.nationality = MangoModel::CountryIso::FR
  ubo.birthday = 105_102_394
  ubo.birthplace = build_birthplace
  ubo
end