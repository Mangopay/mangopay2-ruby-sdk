# To be extended in order to render a class non-instantiable
module NonInstantiable
  def initialize(*_args)
    raise "Cannot instantiate #{self.class.name.split('::').last}"
  end
end