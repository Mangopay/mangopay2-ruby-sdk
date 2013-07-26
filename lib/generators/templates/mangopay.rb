MangoPay.configure do |c|
  c.preproduction = <%= options[:preproduction] %>
  c.client_id = <%= @client_id %>
  c.client_passphrase = <%= client_passphrase %>
end
