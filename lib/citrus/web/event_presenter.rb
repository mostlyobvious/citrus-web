require 'time'

module Citrus
  module Web
    class EventPresenter

      takes :build_presenter

      def call(event)
        event_hash = {}
        event_hash['timestamp'] = event.timestamp.iso8601
        event_hash['kind']      = event.kind.to_s
        event_hash['build']     = {}

        if build = event.build
          event_hash['build'] = build_presenter.(build)
        end

        return event_hash
      end

    end
  end
end
