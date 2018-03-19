require_relative '../common/jsonifier'

module MangoModel

  # Models a platform's categorization details
  class PlatformCategorization
    include MangoPay::Jsonifier

    # [BusinessType] Type of the business
    attr_accessor :business_type

    # [Sector] Sector of business
    attr_accessor :sector
  end
end