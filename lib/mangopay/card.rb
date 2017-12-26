module MangoPay

  # See http://docs.mangopay.com/api-references/card/
  class Card < Resource
    include HTTPCalls::Fetch
    include HTTPCalls::Update
    class << self

      # Retrieves a list of cards having the same fingerprint.
      # The fingerprint is a hash code uniquely generated
      # for each 16-digit card number.
      #
      # @param +fingerprint+ The fingerprint hash code
      # @param +filters+ Optional - a hash accepting following keys:
      # - +page+, +per_page+, +sort+: pagination and sorting params (see MangoPay::HTTPCalls::Fetch::ClassMethods#fetch)
      def get_by_fingerprint(fingerprint, filters = {})
        MangoPay.request(:get, fingerprint_url(fingerprint), {}, filters)
      end

      def fingerprint_url(fingerprint)
        "#{MangoPay.api_path}/cards/fingerprints/#{fingerprint}"
      end
    end
  end
end
