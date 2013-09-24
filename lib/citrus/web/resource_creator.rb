module Citrus
  module Web
    class ResourceCreator

      takes :injector

      def call(route, request, response)
        resource = route.resource.new(request, response)
        resource.injector = injector
        resource
      end

    end
  end
end
