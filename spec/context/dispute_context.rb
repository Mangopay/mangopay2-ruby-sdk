require_relative 'wallet_context'
require_relative '../../lib/mangopay/api/service/disputes'

shared_context 'dispute_context' do
  include_context 'wallet_context'

  DISPUTE_PERSISTED ||= first_dispute
end

def first_dispute
  MangoApi::Disputes.all[0]
end

def its_the_same_dispute(dispute1, dispute2)
  dispute1.contest_deadline_date == dispute2.contest_deadline_date\
    && its_the_same_money(dispute1.contested_funds, dispute2.contested_funds)\
    && its_the_same_money(dispute1.disputed_funds, dispute2.disputed_funds)\
    && its_the_same_reason(dispute1.dispute_reason, dispute2.dispute_reason)\
    && dispute1.dispute_type.eql?(dispute2.dispute_type)\
    && dispute1.initial_transaction_id == dispute2.initial_transaction_id\
    && dispute1.initial_transaction_type.eql?(dispute2.initial_transaction_type)\
    && dispute1.repudiation_id == dispute2.repudiation_id\
    && dispute1.result_code == dispute2.result_code\
    && dispute1.result_message == dispute2.result_message\
    && dispute1.status.eql?(dispute2.status)\
    && dispute1.status_message == dispute2.status_message
end

def its_the_same_money(money1, money2)
  money1.currency.eql?(money2.currency)\
    && money1.amount == money2.amount
end

def its_the_same_reason(reason1, reason2)
  reason1.dispute_reason_message == reason2.dispute_reason_message\
    && reason1.dispute_reason_type.eql?(reason2.dispute_reason_type)
end