module MangoPay
  class CardRegistration < Resource
    include HTTPCalls::Create
    include HTTPCalls::Update
    include HTTPCalls::Fetch
  end
end
