module MangoPay
  class Hook < Resource
    include HTTPCalls::Create
    include HTTPCalls::Update
    include HTTPCalls::Fetch
  end
end
