module Citrus
  module Web
    class BuildConsoleResource < Resource

      inject :builds_repository

      def initialize
        response.headers['Connection']    ||= 'keep-alive'
        response.headers['Cache-Control'] ||= 'no-cache'
      end

      def allowed_methods
        %w(GET)
      end

      def content_types_provided
        [['text/event-stream', :render_event]]
      end

      def resource_exists?
        builds_repository.find_by_uuid(request.path_info[:build_id])
        true
      rescue BuildsRepository::NotFound
        false
      end

      def render_event
        build    = builds_repository.find_by_uuid(request.path_info[:build_id])
        streamer = FileStreamer.new(build.output.path)

        Fiber.new do
          streamer.stream do |data|
            Fiber.yield(encode_sse(data)) unless data.empty?
          end
        end
      end

      def encode_sse(data)
        "data: #{data.strip}\n\n"
      end

    end
  end
end
