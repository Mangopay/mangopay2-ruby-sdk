require_relative '../../../util/non_instantiable'

module MangoModel

  # User entity's base class. Should not be instantiated.
  class User < EntityBase
    extend NonInstantiable

    # Type of user, one of +PersonType+
    attr_accessor :person_type

    # Their KYC level, one of +KycLevel+
    attr_accessor :kyc_level

    # Their email address
    attr_accessor :email
  end
end