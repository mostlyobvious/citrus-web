require 'webmachine/test'
require 'tmpdir'

module Citrus
  module Web
    module TestApplication
      include Webmachine::Test

      def app
        webmachine = Application.new(configuration).webmachine
        webmachine.dispatcher.resource_creator = ResourceCreator.new(injector)
        webmachine
      end

      def configuration
        @configuration ||= Configuration.new(Dir.mktmpdir('citrus'), streamer_url)
      end

      def injector
        @injector ||= fake(:injector)
      end

      def streamer_url
        'http://stream.citrus-ci.dev'
      end

    end
  end
end
