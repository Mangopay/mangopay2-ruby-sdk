require_relative '../lib/mangopay'
require_relative './lib/mangopay/shared_resources'

require 'capybara/rspec'
require 'capybara-webkit'

Capybara.default_driver = :webkit

MangoPay.configure do |c|
  c.preproduction = true
  c.client_id = 'example'
  c.client_passphrase = 'uyWsmnwMQyTnqKgi8Y35A3eVB7bGhqrebYqA1tL6x2vYNpGPiY'
  #c.temp_dir = 'D:/tmp'
end

#MangoPay::AuthorizationToken::Manager.storage = MangoPay::AuthorizationToken::FileStorage.new 'D:/tmp'
