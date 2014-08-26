module MangoPay
  # @abstract
  class Resource
    class << self
      def class_name
        name.split('::').last
      end

      def url(id = nil)
        if self == Resource
          raise NotImplementedError.new('Resource is an abstract class. Do not use it directly.')
        end
        if id
          "#{MangoPay.api_path}/#{CGI.escape(class_name.downcase)}s/#{CGI.escape(id.to_s)}"
        else
          "#{MangoPay.api_path}/#{CGI.escape(class_name.downcase)}s"
        end
      end
    end
  end
end
