module MangoPay
  class Transfer < Resource
    include HTTPCalls::Create
    include HTTPCalls::Fetch
    include HTTPCalls::Refund
  end
end
