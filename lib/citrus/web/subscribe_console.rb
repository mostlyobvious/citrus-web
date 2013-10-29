module Citrus
  module Web
    class SubscribeConsole

      takes :pubsub_adapter

      def call(build_id, client_id)
        pubsub_adapter.publish('subscribe_console', "#{build_id} #{client_id}")
      end

    end
  end
end
