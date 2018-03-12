require_relative '../../util/enum'

module MangoModel

  # Report status enumeration
  class ReportStatus
    extend Enum

    PENDING = value 'PENDING'

    EXPIRED = value 'EXPIRED'

    FAILED = value 'FAILED'

    READY_FOR_DOWNLOAD = value 'READY_FOR_DOWNLOAD'
  end
end