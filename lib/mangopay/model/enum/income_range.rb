require_relative '../../util/non_instantiable'

module MangoModel

  # Users' income ranges enumeration
  class IncomeRange
    extend NonInstantiable

    BELOW_18 = 1

    BETWEEN_18_30 = 2

    BETWEEN_30_50 = 3

    BETWEEN_50_80 = 4

    BETWEEN_80_120 = 5

    ABOVE_120 = 6
  end
end