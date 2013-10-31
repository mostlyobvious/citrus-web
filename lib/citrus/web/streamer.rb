module Citrus
  module Web
    class Streamer

      takes :configuration, :subscriptions_repository, :encoder, :zmq_context

      def run
        Thread.new do
          eager_load_sockets
          poller = ZMQ::Poller.new
          [event_socket, build_console_socket].each { |socket| poller.register_readable(socket) }
          loop do
            poller.poll
            poller.readables.each { |socket| process(socket) }
          end
        end
      end

      protected

      def process(socket)
        socket.recv_string(message = '')
        subject, payload = message.split(' ', 2)
        client_ids = subscriptions_repository.find_all_by_subject(subject).map { |subscription| subscription.client_id }
        deliver(client_ids, encoder.(payload)) unless client_ids.empty?
      end

      def deliver(client_ids, payload)
        mongrel_socket.send_string("#{configuration.mongrel_uuid} #{TNetstring.dump([*client_ids].join(' '))} #{payload}")
      end

      def event_socket
        @event_socket ||= zmq_context.socket(ZMQ::SUB).tap do |socket|
          socket.connect(configuration.event_pubsub_address)
          socket.setsockopt(ZMQ::SUBSCRIBE, 'events')
        end
      end

      def build_console_socket
        @build_console_socket ||= zmq_context.socket(ZMQ::SUB).tap do |socket|
          socket.connect(configuration.build_console_pubsub_address)
          socket.setsockopt(ZMQ::SUBSCRIBE, '')
        end
      end

      def mongrel_socket
        @mongrel_socket ||= zmq_context.socket(ZMQ::PUB).tap do |socket|
          socket.connect(configuration.mongrel_send_address)
        end
      end

      def eager_load_sockets
        event_socket
        build_console_socket
        mongrel_socket
      end

    end
  end
end
