require 'nanomsg'

module Citrus
  module Web
    module NanoPubsubAdapter
      class Publisher

        attr_reader :socket, :address

        def initialize(address)
          @address = address
          @socket  = NanoMsg::PubSocket.new
          socket.bind(address)
        end

        def publish(subject, message)
          socket.send("#{subject} #{message}")
        end

      end

      class Subscriber

        attr_reader :socket, :address

        def initialize(address)
          @address = address
          @socket  = NanoMsg::SubSocket.new
          socket.connect(address)
        end

        def subscribe(subject, &block)
          socket.subscribe(subject)
          loop { block.call(socket.recv.split(' ')[1..-1].join(' ')) }
        end

      end
    end
  end
end
