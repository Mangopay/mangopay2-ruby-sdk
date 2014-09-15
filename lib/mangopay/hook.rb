module MangoPay

  # See http://docs.mangopay.com/api-references/notifications/
  class Hook < Resource
    include HTTPCalls::Create
    include HTTPCalls::Update
    include HTTPCalls::Fetch
  end
end
