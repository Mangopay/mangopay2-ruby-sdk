require_relative 'enum'

# Storage strategy enumeration
class StorageStrategy
  extend Enum

  MEMORY = value 'MEMORY'

  FILE = value 'FILE'
end