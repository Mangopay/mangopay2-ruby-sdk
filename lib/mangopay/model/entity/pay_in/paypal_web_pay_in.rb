require_relative '../../../common/jsonifier'

module MangoModel

  class PaypalWebPayIn < PayIn
    include MangoPay::Jsonifier

    attr_accessor :shipping_address

    attr_accessor :paypal_buyer_account_email

    attr_accessor :return_url
  end

end
