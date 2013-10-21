require 'json'

module Citrus
  module Web
    class EventBusResource < Resource

      # inject :subscribe_events, :event_presenter
      inject :configuration

      # def initialize
      #   response.headers['Connection']    ||= 'keep-alive'
      #   response.headers['Cache-Control'] ||= 'no-cache'
      # end

      def allowed_methods
        %w(GET)
      end

      def content_types_provided
        [['text/html', :render_html]]
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
