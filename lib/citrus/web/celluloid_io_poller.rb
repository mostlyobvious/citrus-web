module Citrus
  module Web
    class CelluloidIOPoller

      def wait_readable(io)
        Celluloid::IO.wait_readable(io)
      end

      def wait_writable(io)
        Celluloid::IO.wait_readable(io)
      end

    end
  end
end
