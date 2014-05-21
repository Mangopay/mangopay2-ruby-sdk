module MangoPay
  class Card < Resource
    include HTTPCalls::Fetch
    include HTTPCalls::Update
  end
end
