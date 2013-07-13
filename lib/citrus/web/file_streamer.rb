module Citrus
  module Web
    class FileStreamer

      attr_reader :path, :notifier

      def initialize(path, notifier = FilesystemEventsNotifier.new)
        @path = path
        @notifier = notifier
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
          wait_readable
          notifier.process
        end
      end

      protected

      def wait_readable
        Celluloid::IO.wait_readable(notifier.to_io)
      end

    end
  end
end

