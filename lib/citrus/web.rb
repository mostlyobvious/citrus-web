require 'citrus/core'
require 'webmachine'

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

require 'citrus/web/resource'
require 'citrus/web/resource_creator'
require 'citrus/web/github_push_resource'
require 'citrus/web/log_subscriber'
require 'citrus/web/application'
