module Citrus
  module Web
    class Application

      extend Dependor::Injectable
      inject :resource_creator, :build_executor, :unsubscribe_client

      def initialize(configuration, build_queue = Queue.new, builds_repository = BuildsRepository.new, subscriptions_repository = SubscriptionsRepository.new)
        @configuration            = configuration
        @build_queue              = build_queue
        @builds_repository        = builds_repository
        @subscriptions_repository = subscriptions_repository
      end

      def webmachine
        @webmachine ||= begin
          webmachine = Webmachine::Application.new
          webmachine.configure do |config|
            config.adapter = :M2R
            config.adapter_options[:on_disconnect] = unsubscribe_client
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
        Injector.new(configuration, build_queue, builds_repository, subscriptions_repository)
      end

      attr_reader :configuration, :build_queue, :builds_repository, :subscriptions_repository

    end
  end
end
