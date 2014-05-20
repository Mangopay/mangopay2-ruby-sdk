module MangoPay
  class Card < Resource
    include MangoPay::HTTPCalls::Fetch
    include MangoPay::HTTPCalls::Update
  end
end
