require_relative '../../lib/mangopay/api/service/disputes'
require_relative '../../lib/mangopay/api/service/repudiations'

shared_context 'repudiation_context' do

  REPUDIATION_PERSISTED ||= persisted_repudiation
end

def persisted_repudiation
  disputes = MangoApi::Disputes.all do |filter|
    filter.per_page = 100
  end
  id = nil
  disputes.each do |dispute|
    id = dispute.repudiation_id if dispute.repudiation_id
  end
  raise 'no repudiation found' unless id
  MangoApi::Repudiations.get id
end