require_relative '../../../common/jsonifier'

module MangoModel

  # User entity of +PersonType::NATURAL+
  # A Natural User represents an actual person.
  class NaturalUser < User
    include MangoPay::Jsonifier

    # [String] Their first name
    attr_accessor :first_name

    # [String] Their last name
    attr_accessor :last_name

    # [Address] Their address
    attr_accessor :address

    # [Integer] Their date of birth (UNIX timestamp)
    attr_accessor :birthday

    # [String] Their place of birth
    attr_accessor :birthplace

    # [CountryIso] Their nationality
    attr_accessor :nationality

    # [CountryIso] Their current country of residence
    attr_accessor :country_of_residence

    # [String] Their occupation
    attr_accessor :occupation

    # [Integer] Their income range (see MangoModel::IncomeRange)
    attr_accessor :income_range

    # [String] Proof of their identity
    attr_accessor :proof_of_identity

    # [String] Proof of their address
    attr_accessor :proof_of_address

    # [String] Their capacity within MangoPay
    attr_accessor :capacity

    def initialize
      self.person_type = PersonType::NATURAL
    end
  end
end