require_relative '../../../common/jsonifier'

module MangoModel

  class GooglePayPayIn < PayIn
    include MangoPay::Jsonifier

    # [String] Custom description to appear on the user's bank statement.
    # (max 100 alphanumeric/spaces)
    attr_accessor :statement_descriptor

    attr_accessor :payment_data

    attr_accessor :return_url

    attr_accessor :billing
  end

  class GooglePayPaymentData

    attr_accessor :transaction_id

    attr_accessor :network

    attr_accessor :token_data
  end

end
