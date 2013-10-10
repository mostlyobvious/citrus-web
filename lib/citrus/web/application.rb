module Citrus
  module Web
    class Application

      extend Dependor::Injectable
      inject :resource_creator, :build_executor

      takes :configuration

      def webmachine
        @webmachine ||= begin
          webmachine = Webmachine::Application.new
          webmachine.configure do |config|
            config.adapter = :Rack
          end
          webmachine.routes do
            add ['github_push'], GithubPushResource
            add ['builds', :build_id, 'console'], BuildConsoleResource
            add ['events'], EventBusResource
          end
          webmachine.dispatcher.resource_creator = resource_creator
          webmachine
        end
      end

      def rack_application
        webmachine.adapter
      end

      def start
        build_executor.start
      end

      protected

      def injector
        Injector.new(configuration)
      end

    end
  end
end
