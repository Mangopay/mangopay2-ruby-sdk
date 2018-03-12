require_relative '../../util/enum'

module MangoModel

  # Dispute status enumeration
  class DisputeStatus
    extend Enum

    CREATED = value 'CREATED'

    PENDING_CLIENT_ACTION = value 'PENDING_CLIENT_ACTION'

    SUBMITTED = value 'SUBMITTED'

    PENDING_BANK_ACTION = value 'PENDING_BANK_ACTION'

    REOPENED_PENDING_CLIENT_ACTION = value 'REOPENED_PENDING_CLIENT_ACTION'

    CLOSED = value 'CLOSED'
  end
end