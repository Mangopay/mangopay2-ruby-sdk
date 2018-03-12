require_relative 'common/log_provider'
require_relative 'common/rate_limit_interval'

module MangoPay

  # Holds environment-specific configuration and data.
  # Allows for multiple client handling and configuration
  # from within the same application.
  class Environment
    LOG = LogProvider.provide(self)

    # [Symbol] Its identification symbol
    attr_reader :id

    # [Configuration] Its MangoPay configuration details
    attr_accessor :configuration

    # [Hash] Counts of the requests sent to the API per time interval
    attr_accessor :rate_limit_count

    # [Hash] Number of remaining possible calls to be made per time interval
    attr_accessor :rate_limit_remaining

    # [Hash] UNIX times at which counts will be reset per time interval
    attr_accessor :rate_limit_reset

    def initialize(id)
      @id = id
      @rate_limit_count = {}
      @rate_limit_remaining = {}
      @rate_limit_reset = {}
    end

    # Updates the rate limit data based on headers from API.
    #
    # noinspection RubyResolve
    def update_rate_limits(rate_limits)
      rate_limits['x-ratelimit'].each.with_index do |count, index|
        @rate_limit_count[time_interval(index)] = count
      end
      rate_limits['x-ratelimit-remaining'].each.with_index do |remain, index|
        @rate_limit_remaining[time_interval(index)] = remain
      end
      rate_limits['x-ratelimit-reset'].each.with_index do |reset, index|
        @rate_limit_reset[time_interval(index)] = reset
      end
    end

    # Asserts the time interval corresponding to each index
    # of the values returned in API headers.
    def time_interval(index)
      case index
      when 0
        RateLimitInterval::FIFTEEN_MIN
      when 1
        RateLimitInterval::THIRTY_MIN
      when 2
        RateLimitInterval::HOUR
      when 3
        RateLimitInterval::DAY
      else
        LOG.warn 'Unexpected rate limit time interval count'
      end
    end
  end
end