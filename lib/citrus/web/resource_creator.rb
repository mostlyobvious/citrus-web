module Citrus
  module Web
    class ResourceCreator

      attr_reader :queue

      def initialize(queue)
        @queue = queue
      end

      def call(route, request, response)
        resource = route.resource.new(request, response)
        resource.queue = queue
        resource
      end

    end
  end
end
