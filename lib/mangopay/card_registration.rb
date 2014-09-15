module MangoPay

  # See http://docs.mangopay.com/api-references/card-registration/
  class CardRegistration < Resource
    include HTTPCalls::Create
    include HTTPCalls::Update
    include HTTPCalls::Fetch
  end
end
