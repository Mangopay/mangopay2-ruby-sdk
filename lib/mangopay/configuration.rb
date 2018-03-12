module MangoPay

  # Top-level configuration details
  class Configuration

    # [true/false] True if the sandbox environment should be used
    attr_accessor :preproduction

    # [String] Root URL to use for requests
    attr_accessor :root_url

    # [String] Your client ID
    attr_accessor :client_id

    # [String] Your client passphrase
    attr_accessor :client_passphrase

    # [String] Path to directory in which to store authorization token
    #          If nil, tokens will be stored in-memory.
    attr_accessor :temp_dir

    # [String] Path for logging file
    attr_accessor :log_dir

    # [Integer] Number of milliseconds after which to timeout requests
    attr_accessor :http_timeout

    def initialize
      self.preproduction = true
      self.http_timeout = 10_000
    end

    def api_version
      'v2.01'
    end

    alias preproduction? preproduction
  end
end