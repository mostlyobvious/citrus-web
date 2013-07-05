require 'citrus/web'

module Citrus
  module Web
    class Application

      attr_reader :queue, :queued_builder, :resource_creator, :execute_build_service, :workspace_builder, :test_runner, :configuration_loader, :log_subscriber

      def initialize
        @log_subscriber        = LogSubscriber.new(Web.log_root.join('build.log'))
        @queue                 = Queue.new
        @test_runner           = Core::TestRunner.new
        @workspace_builder     = Core::WorkspaceBuilder.new
        @configuration_loader  = Core::ConfigurationLoader.new
        @execute_build_service = Core::ExecuteBuildService.new(workspace_builder, configuration_loader, test_runner)
        @queued_builder        = Core::QueuedBuilder.new(execute_build_service, queue)
        @resource_creator      = ResourceCreator.new(queue)
      end

      def webmachine
        @webmachine ||= begin
          webmachine = Webmachine::Application.new
          webmachine.configure do |config|
            config.adapter = :Rack
          end
          webmachine.routes do
            add ['github_push'], GithubPushResource
          end
          webmachine.dispatcher.resource_creator = resource_creator
          webmachine
        end
      end

      def rack_application
        webmachine.adapter
      end

      def start
        subscribe_notifiers
        start_background_tasks
      end

      protected

      def start_background_tasks
        queued_builder.start(concurrency = 1)
      end

      def subscribe_notifiers
        execute_build_service.add_subscriber(log_subscriber)
      end

    end
  end
end
