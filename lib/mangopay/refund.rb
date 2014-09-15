module MangoPay

  # See http://docs.mangopay.com/api-references/refund/
  class Refund < Resource
    include HTTPCalls::Fetch
  end
end
