require 'securerandom'

module Citrus
  module Web
    class Configuration

      attr_reader :root

      def initialize(root)
        @root = root
      end

      def cache_root
        File.join(root, 'cache')
      end

      def build_root
        File.join(root, 'builds')
      end

      def pubsub_address
        'ipc:///tmp/citrus_pubsub.ipc'
      end

    end
  end
end
