require_relative '../util/enum'

module MangoPay

  # MangoPay API rate limit reset times enumeration
  class RateLimitInterval
    extend Enum

    FIFTEEN_MIN = value 'FIFTEEN_MINUTES'

    THIRTY_MIN = value 'THIRTY_MINUTE'

    HOUR = value 'HOUR'

    DAY = value 'DAY'
  end
end