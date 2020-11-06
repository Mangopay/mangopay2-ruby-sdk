require_relative '../uri_provider'
require_relative '../../model/request/filter_request'

module MangoApi

  # Provides API method delegates concerning the +User+ entity.
  module Users
    class << self
      include UriProvider

      # Creates a new user entity.
      #
      # +User+ properties:
      # * +NaturalUser+
      #   * +first_name+ - required
      #   * +last_name+ - required
      #   * +birthday+ - required
      #   * +nationality+ - required
      #   * +country_of_residence+ - required
      #   * +email+ - required
      #   * +tag+ - optional
      #   * +address+ - optional
      #   * +occupation+ - optional
      #   * +income_range+ - optional
      #   * +capacity+ - optional
      # * +LegalUser+
      #   * +legal_person_type+ - required
      #   * +name+ - required
      #   * +legal_representative_birthday+ - required
      #   * +legal_representative_country_of_residence+ - required
      #   * +legal_representative_nationality+ - required
      #   * +legal_representative_first_name+ - required
      #   * +legal_representative_last_name+ - required
      #   * +email+ - required
      #   * +tag+ - optional
      #   * +headquarters_address+ - optional
      #   * +legal_representative_address+ - optional
      #   * +legal_representative_email+ - optional
      #   * +company_number+ - optional
      #
      # +User+ properties:
      # * Optional
      #   * tag
      #   * declared_ubos
      #
      # @param +user+ [User] model object of user to be created
      # @param +id_key+ [String] idempotency key for future response replication
      # @return [User] the newly-created User entity object
      def create(user, id_key = nil)
        uri = provide_uri(:create_user, user)
        response = HttpClient.post(uri, user, id_key)
        parse response
      end

      # Updates the user entity identifiable by
      # the provided user object's ID.
      #
      # +User+ optional properties:
      # * +NaturalUser+
      #   * tag
      #   * first_name
      #   * last_name
      #   * address
      #   * birthday
      #   * nationality
      #   * country_of_residence
      #   * occupation
      #   * income_range
      #   * email
      # * +Legal_user+
      #   * tag
      #   * headquarters_address
      #   * name
      #   * legal_representative_address
      #   * legal_representative_birthday
      #   * legal_representative_country_of_residence
      #   * legal_representative_nationality
      #   * legal_representative_email
      #   * legal_representative_first_name
      #   * legal_representative_last_name
      #   * legal_person_type
      #   * company_number
      #
      # @param +user+ [User] user object with corresponding ID
      # and updated data
      # @return [User] the updated User entity object
      def update(user)
        uri = provide_uri :update_user,
                          user.person_type.to_s.downcase,
                          user.id
        response = HttpClient.put(uri, user)
        parse response
      end

      # Retrieves a user entity.
      #
      # @param +id+ [String] ID of the user to be retrieved
      # @return [User] the requested entity object
      def get(id)
        uri = provide_uri(:get_user, id)
        response = HttpClient.get(uri)
        parse response
      end

      # Retrieves user entity pages. Allows configuration
      # of paging and sorting parameters by yielding a filtering
      # object to a provided block. When no filters are specified,
      # will retrieve the first page of 10 newest results.
      #
      # Allowed +FilterRequest+ params:
      # * page
      # * per_page
      # * sort_field and sort_direction
      # * before_date
      # * after_date
      #
      # @return [Array] corresponding User entity objects
      def all
        uri = provide_uri(:get_users)
        filter_request = nil
        yield filter_request = FilterRequest.new if block_given?
        results = HttpClient.get(uri, filter_request)
        parse_results results
      end

      def get_block_status(id)
        uri = provide_uri(:get_user_block_status, id)
        response = HttpClient.get(uri)
        parse response
      end

      private

      # Parses an array of JSON-originating hashes into the corresponding
      # User entity objects.
      #
      # @param +results+ [Array] JSON-originating data hashes
      # @return [Array] parsed User entity objects
      def parse_results(results)
        results.collect do |entity|
          parse entity
        end
      end

      # Parses a JSON-originating hash into the corresponding
      # User entity object.
      #
      # @param +response+ [Hash] JSON-originating data hash
      # @return [User] corresponding User entity object
      def parse(response)
        type = user_type(response)
        type.new.dejsonify response
      end

      # Asserts the type of user represented by a hash.
      #
      # @param +hash+ [Hash] source hash
      # @return [Class] type of user represented by the hash
      def user_type(hash)
        case hash['PersonType']
        when MangoModel::PersonType::NATURAL.to_s
          MangoModel::NaturalUser
        else
          MangoModel::LegalUser
        end
      end
    end
  end
end