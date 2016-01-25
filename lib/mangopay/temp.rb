module MangoPay

  module Temp

    # As part of our migration project to allow users
    # to move from v1 to v2 of our API,
    # we have added a couple of temporary calls to the v2 API.
    # 
    # They are not documented in normal way, but the calls are related to:
    # - registering a card (POST & GET /temp/paymentcards)
    # - and doing a web card payin with this card (POST /temp/immediate-payins)
    # For the latter, a GET or refunds are done
    # via the previously existing resources.
    # 
    # !!! WARNING !!!
    # These are TEMPORARY functions and WILL BE REMOVED in the future!
    # You should CONTACT SUPPORT TEAM before using these features
    # or if you have any questions.
    class PaymentCard < Resource

      # POST /temp/paymentcards
      # 
      # Sent data:
      # - UserId e.g. "12424242"
      # - Tag e.g. "my tag"
      # - Culture e.g. "FR"
      # - ReturnURL e.g. "http://mysite.com/return"
      # - TemplateURL e.g. "http://mysite.com/template"
      # 
      # Received data:
      # - UserId e.g. "12424242"
      # - Tag e.g. "my tag"
      # - Culture e.g. "FR"
      # - ReturnURL e.g. "http://mysite.com/return"
      # - TemplateURL e.g. "http://mysite.com/template"
      # - RedirectURL e.g. "http://payline.com/redirect"
      # - Alias e.g. null (but would be e.g. 497010XXXXXX4422 once the user has inputed their info and the card has been successfully registered"
      # - Id: "1213131"
      # - CreationDate: "13452522657"
      include HTTPCalls::Create

      # GET /temp/paymentcards
      # Received data: as above
      include HTTPCalls::Fetch

      # POST /temp/immediate-payins
      # 
      # Sent data:
      # - AuthorId e.g. "121412"
      # - CreditUserId e.g. "121412"
      # - PaymentCardId e.g. "322311"
      # - Tag e.g. "my tag"
      # - CreditedWalletId e.g. "123134"
      # - DebitedFunds e.g. normal Money object of Currency and Amount
      # - Fees e.g. normal Money object of Currency and Amount
      # 
      # Received data:
      # Normal card web payin transaction, with the addition of:
      # - PaymentCardId e.g. "322311"
      def self.immediate_payin(params, idempotency_key = nil)
        url = "#{MangoPay.api_path}/temp/immediate-payins"
        MangoPay.request(:post, url, params, {}, idempotency_key)
      end

      def self.url(id = nil)
        if id
          "#{MangoPay.api_path}/temp/paymentcards/#{CGI.escape(id.to_s)}"
        else
          "#{MangoPay.api_path}/temp/paymentcards"
        end
      end
    end
  end
end
