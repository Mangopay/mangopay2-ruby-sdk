require_relative '../../../lib/mangopay/util/enum'

module MangoPay

  # Enumeration of sorting directions available for sorting API response results
  class SortDirection
    extend Enum

    # Ascending sort direction
    ASC = value 'ASC'

    # Descending sort direction
    DESC = value 'DESC'
  end
end