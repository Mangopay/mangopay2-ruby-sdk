require_relative '../lib/mangopay'
require_relative './lib/mangopay/shared_resources'

require 'capybara/rspec'
require 'capybara-webkit'
require 'pp'

Capybara.default_driver = :webkit

def reset_mangopay_configuration
  MangoPay.configure do |c|
    c.preproduction = true
    c.client_id = 'example'
    c.client_passphrase = 'uyWsmnwMQyTnqKgi8Y35A3eVB7bGhqrebYqA1tL6x2vYNpGPiY'
  end
end
reset_mangopay_configuration
