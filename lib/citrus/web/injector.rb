require 'securerandom'
require 'json'

module Citrus
  module Web
    class Injector
      extend Dependor::Let

      takes :configuration, :build_queue, :builds_repository, :subscriptions_repository

      let(:test_runner)                    { Core::TestRunner.new.tap { |tr| tr.add_subscriber(build_console_subscriber) } }
      let(:code_fetcher)                   { Core::CachedCodeFetcher.new(configuration.cache_root) }
      let(:workspace_builder)              { Core::WorkspaceBuilder.new(configuration.build_root, code_fetcher) }
      let(:configuration_loader)           { Core::ConfigurationLoader.new }
      let(:execute_build)                  { Core::ExecuteBuild.new(workspace_builder, configuration_loader, test_runner).tap { |eb| eb.add_subscriber(event_subscriber) } }
      let(:build_executor)                 { ThreadedBuildExecutor.new(execute_build, build_queue) }
      let(:resource_creator)               { ResourceCreator.new(self) }
      let(:github_adapter)                 { Core::GithubAdapter.new }
      let(:create_build)                   { CreateBuild.new(builds_repository, build_queue) }
      let(:publish_events)                 { PublishEvents.new(event_pubsub_publisher, event_presenter) }
      let(:publish_console)                { PublishConsole.new(build_console_pubsub_publisher) }
      let(:event_presenter)                { EventPresenter.new }
      let(:event_subscriber)               { EventSubscriber.new(publish_events, clock) }
      let(:build_console_subscriber)       { BuildConsoleSubscriber.new(publish_console) }
      let(:clock)                          { Clock.new }
      let(:subscribe_console)              { SubscribeConsole.new(subscription_pubsub_publisher) }
      let(:subscribe_events)               { SubscribeEvents.new(subscription_pubsub_publisher) }
      let(:pubsub_serializer)              { JSON }
      let(:zmq_context)                    { @zmq_context ||= ZMQ::Context.new }
      let(:subscription_pubsub_publisher)  { @subscription_pubsub_publisher  ||= ZmqPubsubAdapter::Publisher.new(configuration.subscription_pubsub_address, NullSerializer.new, zmq_context) }
      let(:event_pubsub_publisher)         { @event_pubsub_publisher         ||= ZmqPubsubAdapter::Publisher.new(configuration.event_pubsub_address, JSON, zmq_context) }
      let(:build_console_pubsub_publisher) { @build_console_pubsub_publisher ||= ZmqPubsubAdapter::Publisher.new(configuration.build_console_pubsub_address, NullSerializer.new, zmq_context) }
      let(:unsubscribe_client)             { UnsubscribeClient.new(subscriptions_repository) }
      let(:subscribe_client)               { SubscribeClient.new(subscriptions_repository) }

    end
  end
end
