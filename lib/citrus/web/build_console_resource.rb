module Citrus
  module Web
    class BuildConsoleResource < Resource

      inject :builds_repository, :configuration

      def allowed_methods
        %w(GET)
      end

      def content_types_provided
        [['text/html', :render_html]]
      end

      def resource_exists?
        builds_repository.find_by_uuid(request.path_info[:build_id])
        true
      rescue BuildsRepository::NotFound
        false
      end

      def render_html
        301
      end

      def finish_request
        response.headers['Location'] = configuration.streamer_url
      end

    end
  end
end
