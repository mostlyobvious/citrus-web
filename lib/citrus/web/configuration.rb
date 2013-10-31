require 'securerandom'

module Citrus
  module Web
    class Configuration

      takes :root

      def cache_root
        File.join(root, 'cache')
      end

      def build_root
        File.join(root, 'builds')
      end

      def event_pubsub_address
        'ipc:///tmp/citrus_event_pubsub.ipc'
      end

      def build_console_pubsub_address
        'ipc:///tmp/citrus_build_console_pubsub.ipc'
      end

      def mongrel_receive_address
        'tcp://127.0.0.1:1234'
      end

      def mongrel_send_address
        'tcp://127.0.0.1:4321'
      end

      def mongrel_uuid
        '8699e94e-ee48-4274-9461-5907fa0efc4a'
      end

    end
  end
end
