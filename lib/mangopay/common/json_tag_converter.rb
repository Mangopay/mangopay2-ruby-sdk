module MangoPay

  # Converts field names between Ruby and API formats.
  module JsonTagConverter
    class << self

      # Converts a snake_case-named field name to
      # its API UpperCamelCase counterpart.
      def to_json_tag(field)
        field.split('_').collect do |word|
          apply_capitalization! word
        end.join
      end

      # Converts an API-returned UpperCamelCase-named JSON tag
      # to its Ruby-standard snake_case counterpart.
      def from_json_tag(tag)
        tag = tag.sub('UBO', 'Ubo').sub('AVS', 'Avs')
        parts = tag.split(/(?=[A-Z])/)
        parts = compress_upcase_strings(parts)
        field = ''
        parts.each.with_index do |part, index|
          decapitalize! part
          field << '_' if !field.empty? && (part.length > 1\
           || (part == 'e' && parts[index + 1] == 'Money'))
          field << part
        end
        field
      end

      private

      # Applies necessary capitalization to a word
      # in order to match API conventions.
      def apply_capitalization!(word)
        word.sub!('kyc', 'KYC')
        word.sub!('url', 'URL')
        word.sub!('iban', 'IBAN')
        word.sub!('bic', 'BIC')
        word.sub!('aba', 'ABA')
        word.sub!('ubo', 'UBO')
        word.sub!('avs', 'AVS')
        word[0] = word[0].upcase
        word
      end

      # Takes an array of strings and sticks together those
      # which are single uppercase letters in order to form
      # the actual words they compose.
      def compress_upcase_strings(strings)
        result = []
        current = ''
        strings.each do |string|
          if string.length > 1
            result << current unless current.empty?
            current = ''
            result << string
            next
          end
          current << (current.empty? ? string : string.downcase)
        end
        current.empty? ? result : result << current
      end

      def decapitalize!(word)
        word[0] = word[0].downcase
        word
      end
    end
  end
end