module Citrus
  module Web
    class EventSubscriber

      takes :publish_events, :clock

      def build_succeeded(build, result)
        event = Event.new(:build_succeeded, clock.now, build)
        publish_events.('event', event)
      end

      def build_failed(build, result)
        event = Event.new(:build_failed, clock.now, build)
        publish_events.('event', event)
      end

      def build_aborted(build, error)
        event = Event.new(:build_aborted, clock.now, build)
        publish_events.('event', event)
      end

      def build_started(build)
        event = Event.new(:build_started, clock.now, build)
        publish_events.('event', event)
      end

    end
  end
end
