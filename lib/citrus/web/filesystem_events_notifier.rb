module Citrus
  module Web
    class FilesystemEventsNotifier

      extend Forwardable

      attr_reader :notifier
      def_delegators :notifier, :process, :watch, :to_io

      def initialize(platform = RUBY_PLATFORM)
        @notifier = setup_notifier(platform)
      end

      protected

      def setup_notifier(platform)
        case platform
        when /darwin/
          require 'citrus/web/kqueue_filesystem_events_notifier'
          KQueueFilesystemEventsNotifier.new
        when /linux/
          require 'citrus/web/inotify_filesystem_events_notifier'
          INotifyFilesystemEventsNotifier.new
        end
      end

    end
  end
end
