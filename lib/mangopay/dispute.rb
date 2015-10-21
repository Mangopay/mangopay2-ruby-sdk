module MangoPay
  # See http://docs.mangopay.com/api-references/dispute/
  class Dispute < Resource
    include HTTPCalls::Fetch
    include HTTPCalls::Update
  end
end
