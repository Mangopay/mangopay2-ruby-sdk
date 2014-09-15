module MangoPay

  # See http://docs.mangopay.com/api-references/events/
  class Event < Resource

    # Fetches list of events (PayIns, PayOuts, Transfers).
    # 
    # Optional +filters+ is a hash accepting following keys:
    # - +page+, +per_page+, +sort+: pagination and sorting params (see MangoPay::HTTPCalls::Fetch::ClassMethods#fetch)
    # - +EventType+: {PAYIN_NORMAL_CREATED, PAYIN_NORMAL_SUCCEEDED, PAYIN_NORMAL_FAILED etc...} (see http://docs.mangopay.com/api-references/events/)
    # - +BeforeDate+ (timestamp): filters events with Date _before_ this date
    # - +AfterDate+ (timestamp): filters events with Date _after_ this date
    #
    def self.fetch(filters={})
      MangoPay.request(:get, url(), {}, filters)
    end
  end
end
