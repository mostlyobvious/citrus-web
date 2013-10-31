require 'securerandom'

module Citrus
  module Web
    class BuildsRepository
      Error    = Class.new(StandardError)
      NotFound = Class.new(Error)

      attr_reader :builds
      protected   :builds

      def initialize
        @builds = Hash.new
      end

      def create_build(changeset, output)
        uuid  = SecureRandom.uuid
        build = Core::Build.new(changeset, uuid, output)
        builds[uuid] = build
        build
      end

      def find_by_uuid(uuid)
        raise NotFound unless builds.has_key?(uuid)
        builds[uuid]
      end

      def find_all
        @builds.values
      end

    end
  end
end
