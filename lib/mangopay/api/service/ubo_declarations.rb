require_relative '../uri_provider'
require_relative '../../model/request/submit_ubo_declaration_request'

module MangoApi

  # Provides API method delegates for the +UboDeclaration+ entity
  module UboDeclarations
    class << self
      include UriProvider

      # Creates a UBO Declaration entity.
      #
      # +UboDeclaration+ properties:
      # * Optional
      #   * tag
      #   * declared_ubos
      #
      # @param +user_id+ [String] ID of the user who the declaration is
      # being created for
      # @return [UboDeclaration] the newly-created UboDeclaration entity object
      def create(user_id, id_key = nil)
        uri = provide_uri(:create_ubo_declaration, user_id)
        response = HttpClient.post(uri, nil, id_key)
        parse response
      end

      def get_all(user_id, id_key = nil)
        uri = provide_uri(:all_ubo_declaration, user_id)
        response = HttpClient.get(uri, id_key)
        parse_ubo_declarations response
      end

      def get(user_id, ubo_declaration_id, id_key = nil)
        uri = if user_id != nil
                provide_uri(:get_ubo_declaration, user_id, ubo_declaration_id)
              else
                provide_uri(:get_ubo_declaration_by_id, ubo_declaration_id)
              end
        response = HttpClient.get(uri, id_key)
        parse response
      end

      def create_ubo(user_id, ubo_declaration_id, ubo, id_key = nil)
        uri = provide_uri(:create_ubo, user_id, ubo_declaration_id)
        response = HttpClient.post(uri, ubo, id_key)
        parseUbo response
      end

      def update_ubo(user_id, ubo_declaration_id, ubo)
        uri = provide_uri(:update_ubo, user_id, ubo_declaration_id, ubo.id)
        response = HttpClient.put(uri, ubo)
        parseUbo response
      end

      def get_ubo(user_id, ubo_declaration_id, ubo_id, id_key = nil)
        uri = provide_uri(:get_ubo, user_id, ubo_declaration_id, ubo_id)
        response = HttpClient.get(uri, id_key)
        parseUbo response
      end

      # Submits a UBO declaration entity for approval.
      #
      # @param +id+ [String] ID of the UBO declaration to submit
      # @param +tag+ [String] custom data to add with the request
      # @return [UboDeclaration] the submitted UboDeclaration entity object
      def submit(user_id, ubo_declaration_id, tag = nil)
        uri = provide_uri(:submit_ubo_declaration, user_id, ubo_declaration_id)
        submit_request = SubmitUboDeclarationRequest.new(ubo_declaration_id, tag)
        response = HttpClient.put(uri, submit_request)
        parse response
      end

      private

      # Parses a JSON-originating hash into the corresponding
      # UboDeclaration entity object.
      #
      # @param +response+ [Hash] JSON-originating data hash
      # @return [UboDeclaration] corresponding UboDeclaration entity object
      def parse(response)
        MangoModel::UboDeclaration.new.dejsonify response
      end

      def parse_ubo_declarations(results)
        results.collect do |entity|
          parse entity
        end
      end

      def parseUbo(response)
        MangoModel::Ubo.new.dejsonify response
      end
    end
  end
end