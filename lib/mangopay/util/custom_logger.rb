require 'logger'

# Custom Logger implementation which handles concatenation
# of multiple provided arguments into the log message string,
# allowing for much cleaner logging statements.
class CustomLogger < Logger

  def debug(message, *args)
    super(format(message, args))
  end

  def info(message, *args)
    super(format(message, args))
  end

  def warn(message, *args)
    super(format(message, args))
  end

  def error(message, *args)
    super(format(message, args))
  end

  def fatal(message, *args)
    super(format(message, args))
  end

  def format(msg, msg_args)
    msg_args.each do |arg|
      msg.sub! '{}', arg.to_s
    end
    msg
  end
end