module MangoPay
  class Transfer < Resource
    include MangoPay::HTTPCalls::Create
    include MangoPay::HTTPCalls::Fetch
    include MangoPay::HTTPCalls::Refund
  end
end
