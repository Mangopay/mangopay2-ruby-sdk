require_relative '../../../common/jsonifier'

module MangoModel

  # User entity of +PersonType::LEGAL+
  # A Legal User represents a business or an organization.
  class LegalUser < User
    include MangoPay::Jsonifier

    # [String] Their name
    attr_accessor :name

    # [LegalPersonType] Type of legal user
    attr_accessor :legal_person_type

    # [Address] Their headquarters' address
    attr_accessor :headquarters_address

    # [String] Their legal representative's first name
    attr_accessor :legal_representative_first_name

    # [String] Their legal representative's last name
    attr_accessor :legal_representative_last_name

    # [Address] Their legal representative's physical address
    attr_accessor :legal_representative_address

    # [String] Their legal representative's email address
    attr_accessor :legal_representative_email

    # [Integer] Their legal representative's birthday (UNIX timestamp)
    attr_accessor :legal_representative_birthday

    # [CountryIso] Their legal representative's nationality
    attr_accessor :legal_representative_nationality

    # [CountryIso] Their legal representative's country of residence
    attr_accessor :legal_representative_country_of_residence

    # [String] Their statute
    attr_accessor :statute

    # [String] Their proof of registration
    attr_accessor :proof_of_registration

    # [String]
    attr_accessor :company_number

    # [String] Their shareholder declaration
    attr_accessor :shareholder_declaration

    def initialize
      self.person_type = PersonType::LEGAL
    end
  end
end