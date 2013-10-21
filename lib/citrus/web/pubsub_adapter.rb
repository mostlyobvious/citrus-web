require 'ffi-rzmq'

module Citrus
  module Web
    module ZmqPubsubAdapter
      class Publisher

        attr_reader :socket, :address, :serializer, :context

        def initialize(address, serializer = Marshal, context = ZMQ::Context.new)
          @address    = address
          @context    = context
          @socket     = context.socket(ZMQ::PUB)
          @serializer = serializer
          socket.setsockopt(::ZMQ::LINGER, 100)
          socket.bind(address)
        end

        def publish(subject, message)
          socket.send_string("#{subject} #{serializer.dump(message)}")
        end

      end
    end
  end
end
