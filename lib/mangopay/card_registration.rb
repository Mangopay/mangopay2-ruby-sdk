module MangoPay
  class CardRegistration < Resource
    include MangoPay::HTTPCalls::Create
    include MangoPay::HTTPCalls::Update
    include MangoPay::HTTPCalls::Fetch
  end
end
