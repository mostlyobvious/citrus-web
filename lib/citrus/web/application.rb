require 'citrus/web'
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

          app.routes do
            add ['github_push'], Citrus::Web::GithubPushResource
          end
        end
      end

      def rack_application
        webmachine.adapter
      end

    end
  end
end
