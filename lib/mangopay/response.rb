module MangoPay

  # See https://docs.mangopay.com/api-references/api-responses/
  class Response < Resource
    include HTTPCalls::Fetch
  end
end
