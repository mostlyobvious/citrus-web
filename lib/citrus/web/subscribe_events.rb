module Citrus
  module Web
    class SubscribeEvents

      takes :pubsub_adapter

      def call(client_id)
        pubsub_adapter.publish('subscribe_events', client_id)
      end

    end
  end
end
