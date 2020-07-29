require_relative '../uri_provider'
require_relative '../../model/request/complete_registration_request'
require_relative '../../model/request/deactivation_request'

module MangoApi

  # Provides API method delegates concerning the +Card+ entity
  module Cards
    class << self
      include UriProvider

      # Creates a new card registration entity.
      #
      # +CardRegistration+ properties:
      # * Required
      #   * user_id
      #   * currency
      # * Optional
      #   * tag
      #   * card_type
      #
      # @param +card_registration+ [CardRegistration] model object of
      # card registration to be created
      # @param +id_key+ [String] idempotency key for future response replication
      # @return [CardRegistration] the newly-created CardRegistration entity
      # object
      def create_registration(card_registration, id_key = nil)
        uri = provide_uri(:create_card_registration)
        response = HttpClient.post(uri, card_registration, id_key)
        parse_registration response
      end

      # Allows completion of a card registration with the registration
      # data received from the Tokenization Server.
      #
      # @param +registration_data+ [String] registration data from the
      # Tokenization Server
      # @return [CardRegistration] the completed CardRegistration entity
      # object
      def complete_registration(id, registration_data)
        uri = provide_uri(:complete_card_registration, id)
        request = CompleteRegistrationRequest.new(registration_data)
        response = HttpClient.put(uri, request)
        parse_registration response
      end

      # Retrieves a card registration entity.
      #
      # @param +id+ [String] ID of the card registration to retrieve
      # @return [CardRegistration] the requested entity object
      def get_registration(id)
        uri = provide_uri(:get_card_registration, id)
        response = HttpClient.get(uri)
        parse_registration response
      end

      # Retrieves a card entity.
      #
      # @param +id+ [String] ID of the card entity to retrieve
      # @return [Card] the requested Card entity object
      def get(id)
        uri = provide_uri(:get_card, id)
        response = HttpClient.get(uri)
        parse_card response
      end

      # Retrieves pages of a user's card entities.
      # Allows configuration of paging and sorting parameters
      # by yielding a filtering object to a provided block. When
      # no filters are specified, will retrieve the
      # first page of 10 newest results.
      #
      # Allowed +FilterRequest+ params:
      # * page
      # * per_page
      # * sort_field and sort_direction
      #
      # @param +id+ [String] ID of the user whose cards to retrieve
      # @return [Array] array of hashed card entities corresponding
      # to provided filters
      def of_user(id)
        uri = provide_uri(:get_users_cards, id)
        filter_request = nil
        yield filter_request = FilterRequest.new if block_given?
        results = HttpClient.get(uri, filter_request)
        parse_cards results
      end

      # Retrieves pages of card entities corresponding to a
      # certain fingerprint. The Fingerprint is a unique
      # hash key uniquely generated per 16-digit card number.
      #
      # Allowed +FilterRequest+ params:
      # * page
      # * per_page
      # * sort_field and sort_direction
      #
      # @param +fingerprint+ [String] uniquely hashed card number
      # which to search for
      # @return [Array] array of hashed card entities corresponding
      # to provided filters
      def with_fingerprint(fingerprint)
        uri = provide_uri(:get_cards_by_fingerprint, fingerprint)
        filter_request = nil
        yield filter_request = FilterRequest.new if block_given?
        results = HttpClient.get(uri, filter_request)
        parse_cards results
      end

      # Deactivates the card entity specified by an id.
      #
      # @param +id+ [String] ID of the card to deactivate
      # @return [Card] the deactivated card entity object
      def deactivate(id)
        uri = provide_uri(:deactivate_card, id)
        response = HttpClient.put(uri, DeactivationRequest.new)
        parse_card response
      end

      # Validates the card entity specified by an id.
      #
      # @param +id+ [String] ID of the card to validate
      # @return [Card] the validated card entity object
      def validate(id)
        uri = provide_uri(:card_validate, id)
        response = HttpClient.post(uri, nil)
        parse_card response
      end

      private

      # Parses a JSON-originating hash into the corresponding
      # CardRegistration entity object.
      #
      # @param +response+ [Hash] JSON-originating data hash
      # @return [CardRegistration] corresponding CardRegistration entity object
      def parse_registration(response)
        MangoModel::CardRegistration.new.dejsonify response
      end

      # Parses a JSON-originating hash into the corresponding
      # Card entity object.
      #
      # @param +response+ [Hash] JSON-originating data hash
      # @return [Card] corresponding Card entity object
      def parse_card(response)
        MangoModel::Card.new.dejsonify response
      end

      # Parses an array of JSON-originating hashes into the corresponding
      # Card entity objects.
      #
      # @param +results+ [Array] JSON-originating data hashes
      # @return [Array] parsed Card entity objects
      def parse_cards(results)
        results.collect do |entity|
          parse_card entity
        end
      end
    end
  end
end