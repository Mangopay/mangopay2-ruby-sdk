require_relative '../../common/jsonifier'

module MangoModel

  # UBO Declaration entity
  # A UBO Declaration is an electronic version of the previous KYC document
  # of +KycDocumentType::SHAREHOLDER_DECLARATION+, used to declare all the
  # Ultimate Beneficial Owners of a legal user of +LegalPersonType::BUSINESS+
  # (i.e. the shareholders of at least 25% ownership)
  class UboDeclaration < EntityBase
    include MangoPay::Jsonifier

    # [String] ID of its owner
    attr_accessor :user_id

    # [UboDeclarationStatus] Its status
    attr_accessor :status

    # [Array] Array of +UboDeclarationRefusedReasonType+s (reasons why
    # the UBO declaration was refused)
    attr_accessor :refused_reason_types

    # [String] Explanation of why the UBO declaration was refused
    attr_accessor :refused_reason_message

    # [Array] When sending to the API, will be a list of the IDs of the users
    # being declared as UBOs. When retrieving +UboDeclaration+s from the API,
    # will be a list of +DeclaredUboStatus+ objects, representing validation
    # status for each person declared as UBO.
    attr_accessor :declared_ubos
  end
end