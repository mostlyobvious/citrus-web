module Citrus
  module Web
    class SelectPoller

      def wait_readable(io)
        Kernel.select([io])
      end

      def wait_writable(io)
        Kernel.select([], [io])
      end

    end
  end
end
