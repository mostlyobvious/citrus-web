require 'logger'

module Citrus
  module Web
    class LogSubscriber

      attr_reader :logger

      def initialize(log_path)
        @logger = Logger.new(log_path)
      end

      def build_succeeded(build, output)
        logger.info "[#{build.uuid}] Build has succeeded."
        logger.info output
      end

      def build_failed(build, output)
        logger.info "[#{build.uuid}] Build has failed."
        logger.info output
      end

      def build_aborted(build, error)
        logger.info "[#{build.uuid}] Build has been aborted."
        logger.info error
      end

      def build_started(build)
        logger.info "[#{build.uuid}] Build has started."
      end

    end
  end
end
