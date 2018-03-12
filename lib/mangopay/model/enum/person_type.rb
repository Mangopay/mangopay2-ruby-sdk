require_relative '../../util/enum'

module MangoModel

  # Person type enumeration
  class PersonType
    extend Enum

    # Represents a person
    NATURAL = value 'NATURAL'

    # Represents a business or an organization
    LEGAL = value 'LEGAL'
  end
end