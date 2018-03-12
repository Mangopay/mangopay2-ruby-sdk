require_relative '../../../lib/mangopay/util/enum'

module MangoPay

  # Available fields by which to sort API response results
  class SortField
    extend Enum

    CREATION_DATE = value 'CreationDate'

    DATE = value 'Date'
  end
end