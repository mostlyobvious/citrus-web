module Citrus
  module Web
    class FileStreamer

      attr_reader :path, :notifier, :poller

      def initialize(path, notifier = FilesystemEventsNotifier.new, poller = Poller.new)
        @path = path
        @notifier = notifier
        @poller = poller
      end

      def stream(&block)
        file = File.open(path)
        yield file.read
        position = file.stat.size

        notifier.watch(path, :write) do
          file.seek(position)
          yield file.read
          position = file.stat.size
        end

        loop do
          poller.wait_readable(notifier.to_io)
          notifier.process
        end
      end

    end
  end
end

