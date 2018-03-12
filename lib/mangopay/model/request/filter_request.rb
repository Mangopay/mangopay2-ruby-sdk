# Requests filtering of response lists
class FilterRequest

  # [Integer] Number of the page of results to be retrieved
  attr_accessor :page

  # [Integer] Number of results to be included per page
  attr_accessor :per_page

  # [SortField] Field by which to sort results
  attr_accessor :sort_field

  # [SortDirection] Direction of sorting by specified field
  attr_accessor :sort_direction

  # [Integer] Maximum creation date of result entities
  attr_accessor :before_date

  # [Integer] Minimum creation date of result entities
  attr_accessor :after_date

  # [DocumentStatus/TransactionStatus/DisputeStatus] Status of entities
  # to be retrieved
  attr_accessor :status

  # [TransactionNature] Nature of transaction entities to be retrieved
  attr_accessor :nature

  # [TransactionType/DisputeDocumentType] Type of entities to be retrieved
  attr_accessor :type

  # [DisputeType] Type of dispute entities to be retrieved
  attr_accessor :dispute_type

  # [EventType] Type of events to be retrieved
  attr_accessor :event_type

end