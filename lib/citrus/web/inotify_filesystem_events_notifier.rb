require 'rb-inotify'

module Citrus
  module Web

    class INotifyFilesystemEventsNotifier
      extend Forwardable

      attr_reader :notifier
      def_delegators :notifier, :to_io, :process, :watch

      def initialize
        @notifier = INotify::Notifier.new
      end

    end
  end
end
