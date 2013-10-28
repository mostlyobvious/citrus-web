module Citrus
  module Web
    class Application

      extend Dependor::Injectable
      inject :resource_creator, :build_executor

      attr_reader :configuration, :build_queue, :builds_repository

      def initialize(configuration, build_queue = Queue.new, builds_repository = BuildsRepository.new)
        @configuration     = configuration
        @build_queue       = build_queue
        @builds_repository = builds_repository
      end

      def webmachine
        @webmachine ||= begin
          webmachine = Webmachine::Application.new
          webmachine.configure do |config|
            config.adapter = :M2R
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

      def start
        build_executor.start
        webmachine.run
      end

      protected

      def injector
        Injector.new(configuration, build_queue, builds_repository)
      end

    end
  end
end
