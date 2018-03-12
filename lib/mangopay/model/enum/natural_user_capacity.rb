require_relative '../../util/enum'

module MangoModel

  # Capacity of a natural user within MangoPay
  class NaturalUserCapacity
    extend Enum

    # Real customer
    NORMAL = value 'NORMAL'

    # User used only for (UBO) declaration purposes
    DECLARATIVE = value 'DECLARATIVE'
  end
end