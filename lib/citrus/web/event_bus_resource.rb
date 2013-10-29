require 'json'

module Citrus
  module Web
    class EventBusResource < Resource

      inject :subscribe_events

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

      def render_event
        subscribe_events.(client_id)
        200
      end

      def client_id
        request.headers['X-Mongrel2-Connection-Id']
      end

    end
  end
end
