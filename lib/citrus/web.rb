require 'citrus/core'
require 'webmachine'
require 'webmachine/adapters/rack'
require 'thread'
require 'dependor'
require 'dependor/shorty'

module Citrus
  module Web
    class << self

      def root
        Pathname.new(File.expand_path('../../', File.dirname(__FILE__)))
      end

      def log_root
        @log_root ||= root.join('log')
      end

    end
  end
end

require 'citrus/web/injector'
require 'citrus/web/resource'
require 'citrus/web/configuration'
require 'citrus/web/resource_creator'
require 'citrus/web/filesystem_events_notifier'
require 'citrus/web/poller'
require 'citrus/web/file_streamer'
require 'citrus/web/github_push_resource'
require 'citrus/web/build_console_resource'
require 'citrus/web/log_subscriber'
require 'citrus/web/application'
require 'citrus/web/file_output'
require 'citrus/web/threaded_build_executor'
