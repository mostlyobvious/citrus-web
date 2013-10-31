require 'securerandom'
require 'json'

module Citrus
  module Web
    class Injector
      extend Dependor::Let

      takes :configuration, :build_queue, :builds_repository, :subscriptions_repository, :zmq_context

      let(:test_runner)                    { Core::TestRunner.new.tap { |tr| tr.add_subscriber(build_console_subscriber) } }
      let(:code_fetcher)                   { Core::CachedCodeFetcher.new(configuration.cache_root) }
      let(:workspace_builder)              { Core::WorkspaceBuilder.new(configuration.build_root, code_fetcher) }
      let(:configuration_loader)           { Core::ConfigurationLoader.new }
      let(:execute_build)                  { Core::ExecuteBuild.new(workspace_builder, configuration_loader, test_runner).tap { |eb| eb.add_subscriber(event_subscriber) } }
      let(:build_executor)                 { ThreadedBuildExecutor.new(execute_build, build_queue) }
      let(:resource_creator)               { ResourceCreator.new(self) }
      let(:github_adapter)                 { Core::GithubAdapter.new }
      let(:create_build)                   { CreateBuild.new(builds_repository, build_queue) }
      let(:publish_events)                 { PublishEvents.new(event_publisher, event_presenter) }
      let(:publish_console)                { PublishConsole.new(build_console_publisher) }
      let(:event_presenter)                { EventPresenter.new(build_presenter) }
      let(:build_presenter)                { BuildPresenter.new }
      let(:event_subscriber)               { EventSubscriber.new(publish_events, clock) }
      let(:build_console_subscriber)       { BuildConsoleSubscriber.new(publish_console) }
      let(:clock)                          { Clock.new }
      let(:unsubscribe_client)             { UnsubscribeClient.new(subscriptions_repository) }
      let(:subscribe_client)               { SubscribeClient.new(subscriptions_repository) }
      let(:streamer)                       { Streamer.new(configuration, subscriptions_repository, sse_encoder, zmq_context) }
      let(:sse_encoder)                    { ServerSentEventsEncoder.new }
      let(:event_publisher)                { ZmqPubsubAdapter::Publisher.new(configuration.event_pubsub_address, json_serializer, zmq_context) }
      let(:build_console_publisher)        { ZmqPubsubAdapter::Publisher.new(configuration.build_console_pubsub_address, null_serializer, zmq_context) }
      let(:json_serializer)                { JSON }
      let(:null_serializer)                { NullSerializer.new }

    end
  end
end
