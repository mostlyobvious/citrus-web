require 'webmachine'
require 'webmachine/adapters/rack'

module Citrus
  module Web
    class Application

      attr_reader :webmachine

      def initialize
        @webmachine = Webmachine::Application.new do |app|
          app.configure do |config|
            config.adapter = :Rack
          end
        end
      end

      def adapter
        webmachine.adapter
      end

    end
  end
end
