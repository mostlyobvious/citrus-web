require 'rb-kqueue'

module Citrus
  module Web
    class KQueueFilesystemEventsNotifier

      extend Forwardable

      attr_reader :notifier
      def_delegators :notifier, :process

      def initialize
        @notifier = KQueue::Queue.new
      end

      def watch(*args, &block)
        notifier.watch_file(*args, &block)
      end

      def to_io
        @io ||= IO.new(notifier.fd)
      end

    end
  end
end
