require_relative '../../util/enum'

module MangoModel

  # Mandate status enumeration
  class MandateStatus
    extend Enum

    # The mandate has been created
    CREATED = value 'CREATED'

    # The mandate has been submitted to the banks and
    # payments can now be done with this mandate
    SUBMITTED = value 'SUBMITTED'

    # The mandate is active and has been accepted by the
    # banks and/or successfully used in a payment
    ACTIVE = value 'ACTIVE'

    # The mandate has failed for one of a variety of reasons
    # and is no longer available for payments
    FAILED = value 'FAILED'
  end
end