module Citrus
  module Web
    class BuildConsoleResource < Resource

      def initialize
        set_headers
      end

      def set_headers
        response.headers['Connection']    ||= 'keep-alive'
        response.headers['Cache-Control'] ||= 'no-cache'
      end

      def allowed_methods
        %w(GET)
      end

      def content_types_provided
        [['text/event-stream', :render_event]]
      end

      def render_event
        dummy_file = File.new('dummy.log', 'w')
        dummy_file.puts 'initial data'
        dummy_file.close

        streamer = FileStreamer.new(dummy_file.path)
        Fiber.new { streamer.stream { |data| Fiber.yield(data) } }
      end

    end
  end
end
