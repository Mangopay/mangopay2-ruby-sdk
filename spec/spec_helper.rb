require_relative '../lib/mangopay'

MangoPay.configure do |c|
  c.preproduction = true
  c.client_id = 'example'
  c.client_passphrase = 'uyWsmnwMQyTnqKgi8Y35A3eVB7bGhqrebYqA1tL6x2vYNpGPiY'
end
