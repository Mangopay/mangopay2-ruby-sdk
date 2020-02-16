require_relative '../../common/jsonifier'

module MangoModel

  # UBO entity
  class Ubo < EntityBase
    include MangoPay::Jsonifier

    # [String]
    attr_accessor :first_name

    # [String]
    attr_accessor :last_name

    # [Address]
    attr_accessor :address

    # [CountryIso]
    attr_accessor :nationality

    # [Long]
    attr_accessor :birthday

    # [String]
    attr_accessor :birthplace

    # [Bool]
    attr_accessor :is_active
  end
end
