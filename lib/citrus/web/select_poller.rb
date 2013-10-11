module Citrus
  module Web
    class SelectPoller

      def wait_readable(io)
        IO.select([io])
      end

      def wait_writable(io)
        IO.select([], [io])
      end

    end
  end
end
