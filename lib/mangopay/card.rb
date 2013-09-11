module MangoPay
  class Card < Resource
    include MangoPay::HTTPCalls::Fetch
  end
end
