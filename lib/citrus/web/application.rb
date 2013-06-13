require 'citrus/web'
require 'webmachine/adapters/rack'
require 'thread'

module Citrus
  module Web
    class Application

      attr_reader :webmachine, :queue, :queued_builder, :resource_creator, :execute_build_service

      def initialize
        @queue = Queue.new
        @execute_build_service = Citrus::Core::ExecuteBuildService.new
        @queued_builder = Citrus::Core::QueuedBuilder.new(execute_build_service, queue)
        @resource_creator = ResourceCreator.new(queue)
        @webmachine = Webmachine::Application.new
        configure_app
      end

      def rack_application
        webmachine.adapter
      end

      protected

      def configure_app
        webmachine.configure do |config|
          config.adapter = :Rack
        end
        webmachine.routes do
          add ['github_push'], Citrus::Web::GithubPushResource
        end
        webmachine.dispatcher.resource_creator = resource_creator
      end

    end
  end
end
