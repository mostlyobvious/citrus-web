module Citrus
  module Web
    class BuildPresenter

      def call(build)
        build_hash = {}
        build_hash['uuid']      = build.uuid
        build_hash['changeset'] = {}

        changeset = build.changeset
        build_hash['changeset']['repository_url'] = changeset.repository_url
        build_hash['changeset']['commits']        = []

        commits = changeset.commits
        build_hash['changeset']['commits'] = commits.inject([]) do |collection, commit|
          commit_hash = {}
          commit_hash['sha']     = commit.sha
          commit_hash['author']  = commit.author
          commit_hash['message'] = commit.message
          collection << commit_hash
        end

        return build_hash
      end

    end
  end
end
