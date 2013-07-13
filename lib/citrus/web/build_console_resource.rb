require 'rb-kqueue'

class FileWatcher

  attr_reader :path, :notifier

  def initialize(path)
    @path = path
    @notifier = KQueue::Queue.new
  end

  def watch(activity = :write, &block)
    notifier.watch_file(path, activity, &block) if block_given?
  end

  def run
    notifier_io = IO.new(notifier.fd)
    loop do
      Celluloid::IO.wait_readable(notifier_io)
      notifier.process
    end
  end

end

class FileStreamer

  attr_accessor :file, :position, :path

  def initialize(path)
    @path = path
    @file = File.open(path)
    @position = 0
  end

  def stream(&block)
    yield read_from_current_position
    watcher.watch { yield read_from_current_position }
    watcher.run
  end

  protected

  def read_from_current_position
    file.seek(position)
    self.position = file.stat.size
    file.read
  end

  def watcher
    @watcher ||= FileWatcher.new(path)
  end

end


module Citrus
  module Web
    class BuildConsoleResource < Resource

      def initialize
        set_headers
      end

      def set_headers
        response.headers['Connection']    ||= 'keep-alive'
        response.headers['Cache-Control'] ||= 'no-cache'
      end

      def allowed_methods
        %W[GET]
      end

      def content_types_provided
        [['text/event-stream', :render_event]]
      end

      def render_event
        dummy_file = File.new('dummy.log', 'w')
        dummy_file.puts 'initial data'
        dummy_file.close

        streamer = FileStreamer.new(dummy_file.path)
        Fiber.new { streamer.stream { |data| Fiber.yield(data) } }
      end

    end
  end
end
