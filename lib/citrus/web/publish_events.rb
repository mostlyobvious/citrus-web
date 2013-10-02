module Citrus
  module Web
    class PublishEvents

      takes :pubsub_adapter

      def call(subscription_subject, event)
        pubsub_adapter.publish(subscription_subject, event)
      end

    end
  end
end
