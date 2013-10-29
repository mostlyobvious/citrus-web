module Citrus
  module Web
    class BuildConsoleResource < Resource

      inject :builds_repository, :subscribe_console

      def initialize
        response.headers['Connection']        ||= 'keep-alive'
        response.headers['Cache-Control']     ||= 'no-cache'
        response.headers['Transfer-Encoding'] ||= 'identity'
      end

      def allowed_methods
        %w(GET)
      end

      def content_types_provided
        [['text/event-stream', :render_event]]
      end

      def resource_exists?
        builds_repository.find_by_uuid(build_id)
        true
      rescue BuildsRepository::NotFound
        false
      end

      def render_event
        build = builds_repository.find_by_uuid(build_id)
        current_output = build.output.read
        subscribe_console.(build_id, client_id)
        encode_sse(current_output)
      end

      def encode_sse(data)
        "data: #{data.strip}\n\n"
      end

      def build_id
        request.path_info[:build_id]
      end

      def client_id
        request.headers['X-Mongrel2-Connection-Id']
      end

    end
  end
end
