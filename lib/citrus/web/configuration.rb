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

    end
  end
end
