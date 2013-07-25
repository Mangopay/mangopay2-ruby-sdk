module MangoPay
  class Client < Resource
    include MangoPay::HTTPCalls::Create
  end
end
