module Citrus
  module Web
    class Application

      extend Dependor::Injectable
      inject :resource_creator, :build_executor, :unsubscribe_client, :streamer

      def initialize(configuration, zmq_context = ZMQ::Context.new)
        @configuration            = configuration
        @build_queue              = Queue.new
        @builds_repository        = BuildsRepository.new
        @subscriptions_repository = SubscriptionsRepository.new
        @zmq_context              = zmq_context
      end

      def webmachine
        @webmachine ||= begin
          webmachine = Webmachine::Application.new
          webmachine.configure do |config|
            config.adapter = :M2R
            config.adapter_options[:on_disconnect] = unsubscribe_client
            config.adapter_options[:recv_addr]     = configuration.mongrel_receive_address
            config.adapter_options[:send_addr]     = configuration.mongrel_send_address
            config.adapter_options[:sender_id]     = configuration.mongrel_uuid
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
        build_executor.run
        streamer.run
        webmachine.run
      end

      protected

      def injector
        Injector.new(configuration, build_queue, builds_repository, subscriptions_repository, zmq_context)
      end

      attr_reader :configuration, :build_queue, :builds_repository, :subscriptions_repository, :zmq_context

    end
  end
end
