module Citrus
  module Web
    class Resource < Webmachine::Resource

      attr_accessor :queue

      def handle_exception(error)
        $stderr.puts error
        super
      end

    end
  end
end
