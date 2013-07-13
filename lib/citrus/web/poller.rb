module Citrus
  module Web
    class Poller

      extend Forwardable

      attr_reader :poller
      def_delegators :poller, :wait_readable, :wait_writable

      def initialize
        @poller = setup_poller
      end

      protected

      def setup_poller
        if defined?(:Reel)
          require 'citrus/web/celluloid_io_poller'
          CelluloidIOPoller.new
        else
          require 'citrus/web/select_poller'
          SelectPoller.new
        end
      end

    end
  end
end
