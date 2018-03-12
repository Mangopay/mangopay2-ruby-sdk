require_relative '../../lib/mangopay/api/service/hooks'
require_relative '../../lib/mangopay/model/enum/event_type'
require_relative '../../lib/mangopay/model/entity/hook'

shared_context 'hook_context' do

  HOOK_DATA = build_hook
  HOOK_PERSISTED = MangoApi::Hooks.all[0]
end

def build_hook
  hook = MangoModel::Hook.new
  hook.event_type = MangoModel::EventType::PAYIN_REPUDIATION_CREATED
  hook.url = 'http://www.my-site.com/hooks/'
  hook
end