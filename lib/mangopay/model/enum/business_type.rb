require_relative '../../util/enum'

module MangoModel

  # Business type enumeration
  class BusinessType
    extend Enum

    MARKETPLACE = value 'MARKETPLACE'

    CROWDFUNDING = value 'CROWDFUNDING'

    FRANCHISE = value 'FRANCHISE'

    OTHER = value 'OTHER'
  end
end