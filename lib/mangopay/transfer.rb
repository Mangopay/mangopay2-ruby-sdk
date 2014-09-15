module MangoPay

  # See http://docs.mangopay.com/api-references/transfers/
  class Transfer < Resource
    include HTTPCalls::Create
    include HTTPCalls::Fetch
    include HTTPCalls::Refund
  end
end
