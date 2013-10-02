module Citrus
  module Web
    class SubscribeEvents

      takes :pubsub_adapter

      def call(subscription_subject, &block)
        pubsub_adapter.subscribe(subscription_subject) do |event|
          block.call(event)
        end
      end

    end
  end
end
