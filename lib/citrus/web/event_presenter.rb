require 'time'

module Citrus
  module Web
    class EventPresenter

      def call(event)
        event_hash = {}
        event_hash['timestamp'] = event.timestamp.iso8601
        event_hash['kind']      = event.kind.to_s
        event_hash['build']     = {}

        if build = event.build
          event_hash['build']['uuid']      = build.uuid
          event_hash['build']['changeset'] = {}

          changeset = build.changeset
          event_hash['build']['changeset']['repository_url'] = changeset.repository_url
          event_hash['build']['changeset']['commits']        = []

          commits = changeset.commits
          event_hash['build']['changeset']['commits'] = commits.inject([]) do |collection, commit|
            commit_hash = {}
            commit_hash['sha']     = commit.sha
            commit_hash['author']  = commit.author
            commit_hash['message'] = commit.message
            collection << commit_hash
          end
        end

        return event_hash
      end

    end
  end
end
