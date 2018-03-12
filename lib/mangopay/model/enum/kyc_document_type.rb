require_relative '../../util/enum'

module MangoModel

  # KYC Document types enumeration
  class KycDocumentType
    extend Enum

    IDENTITY_PROOF = value 'IDENTITY_PROOF'

    REGISTRATION_PROOF = value 'REGISTRATION_PROOF'

    ARTICLES_OF_ASSOCIATION = value 'ARTICLES_OF_ASSOCIATION'

    SHAREHOLDER_DECLARATION = value 'SHAREHOLDER_DECLARATION'

    ADDRESS_PROOF = value 'ADDRESS_PROOF'
  end
end