module MangoPay

  # Assures that no fields which are considered read-only
  # remain in a hash meant to be sent as a request body.
  module ReadOnlyFields

    @read_only_fields = %w[
      CreationDate, PaymentData
    ]

    class << self

      # Checks whether any of the fields marked as read-only
      # are present in the given hash. Removes those which are.
      #
      # @param +hash+ [Hash] hash to check for read-only fields
      # @return [Hash] the given hash minus any read-only fields
      #
      # noinspection RubyResolve
      def remove_from!(hash)
        @read_only_fields.each do |field|
          hash.delete field
        end
      end
    end
  end
end