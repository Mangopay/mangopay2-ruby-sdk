require_relative '../../common/jsonifier'

module MangoModel

  # Mandate entity
  class Mandate < EntityBase
    include MangoPay::Jsonifier

    # [String] ID of the concerned bank account
    attr_accessor :bank_account_id

    # [String] Its owner's ID
    attr_accessor :user_id

    # [String] URL to redirect to after payment (whether or not successful)
    attr_accessor :return_url

    # [String] URL which to redirect users to for them to proceed
    # with the payment
    attr_accessor :redirect_url

    # [String] URL where the mandate can be downloaded
    attr_accessor :document_url

    # [MandateCultureCode] ISO code of the language to use for the mandate
    # confirmation page
    attr_accessor :culture

    # [MandateScheme] Its type, will only be set once the mandate
    # has been submitted
    attr_accessor :scheme

    # [MandateStatus] Its status
    attr_accessor :status

    # [String] Its result code
    attr_accessor :result_code

    # [String] Explanation of its result
    attr_accessor :result_message

    # [MandateExecutionType] Execution type for its creation
    attr_accessor :execution_type

    # [MandateType] Its type
    attr_accessor :mandate_type

    # [String] Its banking reference
    attr_accessor :bank_reference
  end
end