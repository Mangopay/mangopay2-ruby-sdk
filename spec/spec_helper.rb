require 'mangopay'
require_relative 'mangopay/shared_resources'

require 'fileutils'
require 'pp'

# (re-called once in configuration_spec)
def reset_mangopay_configuration
  MangoPay.configure do |c|
    c.preproduction = true
    c.client_id = 'sdk-unit-tests'
    c.client_passphrase = 'cqFfFrWfCcb7UadHNxx2C9Lo6Djw8ZduLi7J9USTmu8bhxxpju'
    c.temp_dir = File.expand_path('../tmp', __FILE__)
    FileUtils.mkdir_p(c.temp_dir) unless File.directory?(c.temp_dir)
  end
end
reset_mangopay_configuration
