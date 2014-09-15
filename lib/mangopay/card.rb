module MangoPay

  # See http://docs.mangopay.com/api-references/card/
  class Card < Resource
    include HTTPCalls::Fetch
    include HTTPCalls::Update
  end
end
