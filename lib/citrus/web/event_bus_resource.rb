module Citrus
  module Web
    class EventBusResource < Resource

      inject :subscribe_events

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

      def render_event
        Fiber.new do
          subscribe_events.('event') do |event|
            Fiber.yield(encode_sse(event))
          end
        end
      end

      def encode_sse(data)
        "data: #{data.strip}\n\n"
      end

    end
  end
end
