module Citrus
  module Web
    class PublishConsole

      takes :pubsub_adapter

      def call(build_id, data)
        pubsub_adapter.publish(build_id, data)
      end

    end
  end
end
