module MangoPay
  class User < Resource
    include MangoPay::HTTPCalls::Create
    include MangoPay::HTTPCalls::Update
    include MangoPay::HTTPCalls::Fetch
  end
end
