require_relative '../../common/jsonifier'

module MangoModel

  # Client entity
  # The Client object allows viewing and editing of various
  # details concerning the implementing platform.
  class Client
    include MangoPay::Jsonifier

    # [String] Its pretty name
    attr_accessor :name

    # [String] Its registered company name
    attr_accessor :registered_name

    # [String] Its ID
    attr_accessor :client_id

    # [String] Its primary branding colour (Hex code)
    attr_accessor :primary_theme_colour

    # [String] Its primary branding colour for buttons (Hex code)
    attr_accessor :primary_button_colour

    # [String] URL of its logo
    attr_accessor :logo

    # [Array] List of email addresses for contacting its technical
    # support team
    attr_accessor :tech_emails

    # [Array] List of email addresses for contacting its
    # administration/commercial team
    attr_accessor :admin_emails

    # [Array] List of email addresses for contacting its
    # fraud prevention/compliance team
    attr_accessor :fraud_emails

    # [Array] List of email addresses for contacting its billing team
    attr_accessor :billing_emails

    # [String] Description of what its implementing platform does
    attr_accessor :platform_description

    # [PlatformCategorization] Categorization details of the platform
    attr_accessor :platform_categorization

    # [String] Its implementing platform's website URL
    attr_accessor :platform_url

    # [Address] Its company's headquarters' address
    attr_accessor :headquarters_address

    # [String] Its company's tax (or VAT) number
    attr_accessor :tax_number

    # [String] Its company's unique MangoPay reference to be used when
    # contacting the MangoPay team
    attr_accessor :company_reference
  end
end