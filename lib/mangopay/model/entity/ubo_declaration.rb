require_relative '../../common/jsonifier'

module MangoModel

  # UBO Declaration entity
  # A UBO Declaration is an electronic version of the previous KYC document
  # of +KycDocumentType::SHAREHOLDER_DECLARATION+, used to declare all the
  # Ultimate Beneficial Owners of a legal user of +LegalPersonType::BUSINESS+
  # (i.e. the shareholders of at least 25% ownership)
  class UboDeclaration < EntityBase
    include MangoPay::Jsonifier

    # [Int]
    attr_accessor :processed_date

    # [UboDeclarationStatus] Its status
    attr_accessor :status

    # [Array] Array of +UboDeclarationRefusedReasonType+s (reasons why
    # the UBO declaration was refused)
    attr_accessor :reason

    # [String] Explanation of why the UBO declaration was refused
    attr_accessor :message

    # [Array] When sending to the API, will be a list of the IDs of the users
    # being declared as UBOs. When retrieving +Ubo+s from the API,
    attr_accessor :ubos
  end
end