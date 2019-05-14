require_relative 'address_context'
require_relative '../../lib/mangopay/model/entity/client'

shared_context 'client_context' do

  CLIENT_DATA ||= build_client_data
end

def build_client_data
  client = MangoModel::Client.new
  client.primary_theme_colour = '#508c4a'
  client.primary_button_colour = '#d0ae5f'
  client.tech_emails = ['tech@mangopay.com']
  client.admin_emails = ['admin@mangopay.com']
  client.fraud_emails = ['fraud@mangopay.com']
  client.billing_emails = ['billing@mangopay.com']
  client.platform_description = "Test description (time = #{Time.now})"
  client.platform_url = 'https://www.mangopay.com'
  client.headquarters_address = build_address
  client.tax_number = 'FR52BSSS'
  client.headquarters_phone_number = rand(999999999).to_s
  client
end

def its_the_same_client(client1, client2)
  client1.primary_theme_colour == client2.primary_theme_colour\
     && client1.primary_button_colour == client2.primary_button_colour\
     && same_values(client1.tech_emails, client2.tech_emails)\
     && same_values(client1.admin_emails, client2.admin_emails)\
     && same_values(client1.fraud_emails, client2.fraud_emails)\
     && same_values(client1.billing_emails, client2.billing_emails)\
     && client1.platform_description == client2.platform_description\
     && client1.platform_url == client2.platform_url\
     && its_the_same_address(client1.headquarters_address, client2.headquarters_address)\
     && client1.tax_number == client2.tax_number
end

def same_values(array1, array2)
  return false unless array1.length == array2.length
  array1.each do |value|
    return false unless array2.include? value
  end
  true
end