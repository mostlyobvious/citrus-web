module Citrus
  module Web
    class BuildResource < Resource

      inject :builds_repository, :build_presenter, :json_serializer

      def content_types_provided
        [['application/json', :render_json]]
      end

      def allowed_methods
        %w(GET)
      end

      def resource_exists?
        builds_repository.find_by_uuid(build_id)
        true
      rescue BuildsRepository::NotFound
        false
      end

      def render_json
        build = builds_repository.find_by_uuid(build_id)
        json_serializer.dump(build_presenter.call(build))
      end

      protected

      def build_id
        request.path_info[:build_id]
      end

    end
  end
end
