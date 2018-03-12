# Extend in order to apply methods for Enum instantiation.
module Enum

  # Restrict enum instantiation to the +value+ method.
  def self.extended(base)
    base.class_eval do
      disable_instantiation
    end
  end

  def value_of(string)
    value = nil
    constants.each do |const|
      value = const_get const if const.to_s == string
    end
    value
  end

  private

  # Temporary self-called method which instantiates Enums.
  # Assign returned values to accordingly-named constant variables.
  #
  # @param +enum_value+ Representation value for the Enum instance
  def value(enum_value)
    enable_instantiation
    enum_instance = new
    disable_instantiation
    enum_instance.instance_variable_set :@value, enum_value
    enum_instance.define_singleton_method :to_s do
      enum_value.to_s
    end
    enum_instance
  end

  # Enables instantiation of extending class.
  def enable_instantiation
    class_eval do
      define_method :initialize do
      end
    end
  end

  # Disables instantiation of extending class.
  def disable_instantiation
    class_eval do
      define_method :initialize do
        raise 'Use the Enum#value method to instantiate Enums.'
      end
    end
  end
end