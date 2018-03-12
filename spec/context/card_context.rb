require_relative 'user_context'
require_relative '../../lib/mangopay/model/entity/card_registration'
require_relative '../../lib/mangopay/api/service/cards'

shared_context 'card_context' do
  include_context 'user_context'

  CARD_REGISTRATION_DATA ||= build_card_registration
  CARD_REGISTRATION_PERSISTED ||= persist_card_registration CARD_REGISTRATION_DATA
  # MangoPay test data
  CARD_NUMBER ||= '4970100000000154'
  CARD_EXPIRATION ||= '1218'
  CARD_CVX ||= '123'
  CARD_REGISTRATION_COMPLETED ||= complete_card_registration CARD_REGISTRATION_PERSISTED
  CARD ||= retrieve_card CARD_REGISTRATION_COMPLETED.card_id
end

def persist_card_registration(card_registration)
  MangoApi::Cards.create_registration card_registration
end

def complete_card_registration(card_registration)
  test_body = "data=#{card_registration.preregistration_data}" +
         "&accessKeyRef=#{card_registration.access_key}" +
         "&cardNumber=#{CARD_NUMBER}" +
         "&cardExpirationDate=#{CARD_EXPIRATION}" +
         "&cardCvx=#{CARD_CVX}"

  uri = URI(card_registration.card_registration_url)
  response = MangoApi::HttpClient.post_raw(uri) do |request|
    request.body = test_body
  end
  MangoApi::Cards.complete_registration(CARD_REGISTRATION_PERSISTED.id, response.to_s)
end

def build_card_registration
  registration = MangoModel::CardRegistration.new
  registration.user_id = NATURAL_USER_PERSISTED.id
  registration.card_type = MangoModel::CardType::CB_VISA_MASTERCARD
  registration.currency = MangoModel::CurrencyIso::EUR
  registration
end

def retrieve_card(id)
  MangoApi::Cards.get id
end