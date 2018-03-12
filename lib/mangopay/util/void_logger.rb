# Logger implementation which will not print any messages.
class VoidLogger < CustomLogger
  def initialize(*_args); end

  def add(*_args, &_block); end
end