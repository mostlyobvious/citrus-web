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
      let(:execute_build)        { ExecuteBuild.new(workspace_builder, configuration_loader, test_runner) }
      let(:build_executor)       { ThreadedBuildExecutor.new(execute_build, build_queue) }
      let(:resource_creator)     { ResourceCreator.new(self) }
      let(:github_adapter)       { Core::GithubAdapter.new }
      let(:create_build)         { CreateBuild.new(builds_repository, build_queue) }
      let(:builds_repository)    { BuildsRepository.new }
      let(:pubsub_publisher)     { PubSubAdapter::Publisher.new }
      let(:pubsub_subscriber)    { PubSubAdapter::Subscriber.new }
      let(:publish_events)       { PublishEvents.new(pubsub_publisher) }
      let(:subscribe_events)     { SubscribeEvents.new(pubsub_subscriber) }

    end
  end
end
