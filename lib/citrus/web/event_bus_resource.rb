require 'json'

module Citrus
  module Web
    class EventBusResource < Resource

      inject :subscribe_events

      def allowed_methods
        %w(GET)
      end

      def content_types_provided
        [['text/event-stream', :render_event]]
      end

      def render_event
        set_stream_headers
        subscribe_events.(client_id)
        200
      end

      protected

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
