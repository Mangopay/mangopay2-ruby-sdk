require_relative '../../util/enum'

module MangoModel

  # Implementing platform types enumeration
  class PlatformType
    extend Enum

    MARKETPLACE = value 'MARKETPLACE'

    P2P_PAYMENT = value 'P2P_PAYMENT'

    CROWDFUNDING_DONATION = value 'CROWDFUNDING_DONATION'

    CROWDFUNDING_REWARD = value 'CROWDFUNDING_REWARD'

    CROWDFUNDING_EQUITY = value 'CROWDFUNDING_EQUITY'

    CROWDFUNDING_LOAN = value 'CROWDFUNDING_LOAN'

    OTHER = value 'OTHER'
  end
end