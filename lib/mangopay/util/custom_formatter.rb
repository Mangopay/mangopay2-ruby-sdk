# Formatter for log messages
class CustomFormatter < Logger::Formatter
  def call(severity, time, progname, msg)
    "[#{time}] #{five_chars(severity)} - #{progname}: #{msg2str(msg)}\n"
  end

  def five_chars(string)
    result = ''
    (5 - string.length).times { result << ' ' }
    result + string
  end
end