require_relative '../util/custom_logger'
require_relative '../util/void_logger'
require_relative '../util/custom_formatter'

module MangoPay

  # Provides logger objects.
  class LogProvider

    ENABLE_LOGGING = false
    ENABLE_HTTP_LOGGING = false

    class << self

      def provide(context)
        if needs_http_logger(context) && ENABLE_HTTP_LOGGING\
          || (!needs_http_logger(context) && ENABLE_LOGGING)
          logger = CustomLogger.new(STDOUT)
          logger.progname = context.name
          logger.formatter = CustomFormatter.new
          logger
        else
          VoidLogger.new
        end
      end

      private

      def needs_http_logger(context)
        context.name =~ /HttpClient/ || context.name =~ /Jsonifier/
      end
    end
  end
end