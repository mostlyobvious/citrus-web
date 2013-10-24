module Citrus
  module Web
    class PublishEvents

      takes :pubsub_adapter, :event_presenter

      def call(subscription_subject, event)
        pubsub_adapter.publish(subscription_subject, event_presenter.(event))
      end

    end
  end
end
