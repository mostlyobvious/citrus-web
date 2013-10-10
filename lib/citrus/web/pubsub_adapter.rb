require 'nanomsg'

module Citrus
  module Web
    module NanoPubsubAdapter
      class Publisher

        attr_reader :socket, :address, :serializer

        def initialize(address, serializer = Marshal)
          @address    = address
          @socket     = NanoMsg::PubSocket.new
          @serializer = serializer
          socket.bind(address)
        end

        def publish(subject, message)
          socket.send("#{subject} #{serializer.dump(message)}")
        end

      end

      class Subscriber

        attr_reader :socket, :address, :serializer

        def initialize(address, serializer = Marshal)
          @address    = address
          @socket     = NanoMsg::SubSocket.new
          @serializer = serializer
          socket.connect(address)
        end

        def subscribe(subject, &block)
          socket.subscribe(subject)
          loop do
            _, message = socket.recv.split(' ', 2)
            block.call(serializer.load(message))
          end
        end

      end
    end
  end
end
