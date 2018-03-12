require_relative 'user_context'
require_relative '../../lib/mangopay/model/entity/ubo_declaration'
require_relative '../../lib/mangopay/api/service/ubo_declarations'
require_relative '../../lib/mangopay/model/enum/natural_user_capacity'

shared_context 'ubo_declaration_context' do
  include_context 'user_context'

  UBO_DECLARATION_DATA ||= build_ubo_declaration
  UBO_DECLARATION_PERSISTED ||= persist_ubo_declaration UBO_DECLARATION_DATA
end

def persist_ubo_declaration(ubo_decl)
  MangoApi::UboDeclarations.create(ubo_decl, LEGAL_USER_PERSISTED.id)
end

def build_ubo_declaration
  natural_user = NATURAL_USER_DATA
  natural_user.capacity = MangoModel::NaturalUserCapacity::DECLARATIVE
  decl_user1 = persist_user natural_user
  decl_user2 = persist_user natural_user
  ubo_decl = MangoModel::UboDeclaration.new
  ubo_decl.declared_ubos = [decl_user1.id, decl_user2.id]
  ubo_decl
end