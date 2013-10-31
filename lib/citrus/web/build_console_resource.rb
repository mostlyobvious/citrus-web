module Citrus
  module Web
    class BuildConsoleResource < Resource

      inject :builds_repository, :subscribe_client, :sse_encoder

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
        set_stream_headers
        subscribe_client.(client_id, build_id)
        build = builds_repository.find_by_uuid(build_id)
        sse_encoder.(build.output.read)
      end

      def finish_request
        response.headers.delete('Content-Length') if response.headers['Transfer-Encoding']
      end

      protected

      def build_id
        request.path_info[:build_id]
      end

      def client_id
        request.headers['X-Mongrel2-Connection-Id']
      end

      def set_stream_headers
        response.headers['Connection']        ||= 'keep-alive'
        response.headers['Cache-Control']     ||= 'no-cache'
        response.headers['Transfer-Encoding'] ||= 'identity'
      end

    end
  end
end
