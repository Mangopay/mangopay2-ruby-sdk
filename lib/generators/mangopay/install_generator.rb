require 'rails/generators/base'
require 'mangopay'

module Mangopay
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../../templates', __FILE__)
      argument :client_id, type: :string,
        desc: 'The id you want to use to query the MangoPay API (must match with the regex ^[a-z0-9_-]{4,20}$)'
      argument :client_name, type: :string, desc: "Full name of you're organization"
      class_option :preproduction, type: :boolean, default: true, desc: 'Whether or not use the preproduction environment'

      desc 'Installs all the basic configuration of the mangopay gem'
      def setup
        template 'mangopay.rb', 'config/initializers/mangopay.rb'
      end

      protected

      def client_passphrase
        client = MangoPay::Client.create({
          ClientID: client_id,
          Name: client_name
        })
        client['Passphrase']
      end
    end
  end
end
