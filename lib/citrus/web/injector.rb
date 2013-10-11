require 'securerandom'

module Citrus
  module Web
    class Injector
      include Dependor::Let

      takes :configuration

      let(:build_queue)          { Queue.new }
      let(:test_runner)          { Core::TestRunner.new }
      let(:code_fetcher)         { Core::CachedCodeFetcher.new(configuration.cache_root) }
      let(:workspace_builder)    { Core::WorkspaceBuilder.new(configuration.build_root, code_fetcher) }
      let(:configuration_loader) { Core::ConfigurationLoader.new }
      let(:execute_build)        { Core::ExecuteBuild.new(workspace_builder, configuration_loader, test_runner).tap { |eb| eb.add_subscriber(event_subscriber) } }
      let(:build_executor)       { ThreadedBuildExecutor.new(execute_build, build_queue) }
      let(:resource_creator)     { ResourceCreator.new(self) }
      let(:github_adapter)       { Core::GithubAdapter.new }
      let(:create_build)         { CreateBuild.new(builds_repository, build_queue) }
      let(:builds_repository)    { BuildsRepository.new }
      let(:pubsub_publisher)     { NanoPubsubAdapter::Publisher.new(configuration.pubsub_address) }
      let(:pubsub_subscriber)    { NanoPubsubAdapter::Subscriber.new(configuration.pubsub_address) }
      let(:publish_events)       { PublishEvents.new(pubsub_publisher) }
      let(:subscribe_events)     { SubscribeEvents.new(pubsub_subscriber) }
      let(:event_presenter)      { EventPresenter.new }
      let(:event_subscriber)     { EventSubscriber.new(publish_events, clock) }
      let(:clock)                { Clock.new }

    end
  end
end
