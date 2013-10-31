module Citrus
  module Web
    class ThreadedBuildExecutor

      takes :execute_build, :build_queue

      def run(concurrency = 1)
        concurrency.times do
          worker_thread = Thread.new do
            loop { execute_build.(build_queue.pop) }
          end
          workers << worker_thread
        end
      end

      def workers
        @workers ||= Array.new
      end

    end
  end
end
