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
        subscribe_events.('event') do |event|
          # XXX: stream received event
        end
      end

    end
  end
end
