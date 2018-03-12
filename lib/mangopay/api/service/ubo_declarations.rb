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
      # @param +ubo_declaration+ [UboDeclaration] model object of the
      # UBO declaration to be created
      # @param +user_id+ [String] ID of the user who the declaration is
      # being created for
      # @return [UboDeclaration] the newly-created UboDeclaration entity object
      def create(ubo_declaration, user_id, id_key = nil)
        uri = provide_uri(:create_ubo_declaration, user_id)
        response = HttpClient.post(uri, ubo_declaration, id_key)
        parse response
      end

      # Updates the UBO declaration entity identifiable by the provided
      # +UboDeclaration+ object's ID.
      #
      # +UboDeclaration+ optional properties:
      # * tag
      # * status
      # * declared_ubos
      #
      # @param +ubo_declaration+ [UboDeclaration] UBO declaration object
      # with corresponding ID and updated data
      # @return [UboDeclaration] the updated UboDeclaration entity object
      def update(ubo_declaration)
        uri = provide_uri(:update_ubo_declaration, ubo_declaration.id)
        response = HttpClient.put(uri, ubo_declaration)
        parse response
      end

      # Submits a UBO declaration entity for approval.
      #
      # @param +id+ [String] ID of the UBO declaration to submit
      # @param +tag+ [String] custom data to add with the request
      # @return [UboDeclaration] the submitted UboDeclaration entity object
      def submit(id, tag = nil)
        uri = provide_uri(:submit_ubo_declaration, id)
        submit_request = SubmitUboDeclarationRequest.new(tag)
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
    end
  end
end