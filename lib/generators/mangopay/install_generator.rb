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
        begin
          client = client_id_valid?
          remove_file 'config/initializers/mangopay.rb'
          @client_id = client_id
          @client_passphrase = client['Passphrase']
          template 'mangopay.rb', 'config/initializers/mangopay.rb'
        rescue => e
          puts e.message
        end
      end

      protected

      def client_id_valid?
        check_client_id_validity
        check_client_id_availablility
      end

      def check_client_id_validity
        if (/^[a-z0-9_-]{4,20}$/ =~ client_id).nil?
          raise "The client_id must match the regexp ^[a-z0-9_-]{4,20}$"
        end
      end

      def check_client_id_availablility
        client = create_client
        if client['Type'] == 'ClientID_already_exist'
          raise client['Message']
        end
        client
      end

      def create_client
        MangoPay.configure do |c|
          c.preproduction = options[:preproduction]
        end
        MangoPay::Client.create({
          ClientID: client_id,
          Name: client_name
        })
      end
    end
  end
end
