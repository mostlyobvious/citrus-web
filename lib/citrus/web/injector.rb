require 'securerandom'

module Citrus
  module Web
    class Injector
      extend Dependor::Let

      takes :configuration, :build_queue, :builds_repository

      let(:test_runner)          { Core::TestRunner.new }
      let(:code_fetcher)         { Core::CachedCodeFetcher.new(configuration.cache_root) }
      let(:workspace_builder)    { Core::WorkspaceBuilder.new(configuration.build_root, code_fetcher) }
      let(:configuration_loader) { Core::ConfigurationLoader.new }
      let(:execute_build)        { Core::ExecuteBuild.new(workspace_builder, configuration_loader, test_runner).tap { |eb| eb.add_subscriber(event_subscriber) } }
      let(:build_executor)       { ThreadedBuildExecutor.new(execute_build, build_queue) }
      let(:resource_creator)     { ResourceCreator.new(self) }
      let(:github_adapter)       { Core::GithubAdapter.new }
      let(:create_build)         { CreateBuild.new(builds_repository, build_queue) }
      let(:pubsub_publisher)     { ZmqPubsubAdapter::Publisher.new(configuration.pubsub_address, pubsub_serializer, zmq_context) }
      let(:publish_events)       { PublishEvents.new(pubsub_publisher) }
      let(:event_presenter)      { EventPresenter.new }
      let(:event_subscriber)     { EventSubscriber.new(publish_events, clock) }
      let(:clock)                { Clock.new }

      def pubsub_serializer
        Marshal
      end

      def zmq_context
        @zmq_context ||= ZMQ::Context.new
      end

    end
  end
end
