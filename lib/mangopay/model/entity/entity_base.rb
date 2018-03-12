require_relative '../../util/non_instantiable'

module MangoModel

  # Base class for entities which provides common properties
  class EntityBase
    extend NonInstantiable

    # Unique identifier
    attr_accessor :id

    # Custom data
    attr_accessor :tag

    # Date of creation (UNIX timestamp)
    attr_accessor :creation_date
  end
end