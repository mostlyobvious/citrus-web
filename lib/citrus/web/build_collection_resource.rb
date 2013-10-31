module Citrus
  module Web
    class BuildCollectionResource < Resource

      inject :builds_repository, :build_presenter, :json_serializer

      def allowed_methods
        %w(GET)
      end

      def content_types_provided
        [['application/json', :render_json]]
      end

      def render_json
        builds = builds_repository.find_all.map { |build| build_presenter.(build) }
        json_serializer.dump(builds)
      end

    end
  end
end
