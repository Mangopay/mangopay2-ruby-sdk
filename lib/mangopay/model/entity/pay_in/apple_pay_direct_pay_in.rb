require_relative '../../../common/jsonifier'

module MangoModel

  class ApplePayPayIn < PayIn
    include MangoPay::Jsonifier

    # [String] Custom description to appear on the user's bank statement.
    # (max 100 alphanumeric/spaces)
    attr_accessor :statement_descriptor

    attr_accessor :payment_data

    attr_accessor :return_url
  end

  class ApplePayPaymentData

    attr_accessor :transaction_id

    attr_accessor :network

    attr_accessor :token_data
  end

end
