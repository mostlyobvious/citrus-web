module Citrus
  module Web
    class Resource < Webmachine::Resource

      extend Dependor::Injectable
      attr_accessor :injector
      protected     :injector

      def handle_exception(error)
        $stderr.puts error
        super
      end

    end
  end
end
