module Citrus
  module Web
    class GithubPushResource < Resource
      def allowed_methods
        %w(POST)
      end

      def process_post
        changeset = github_adapter.create_changeset_from_push_data(request.body.to_s)
        build = Citrus::Core::Build.new(changeset)
        queue.push(build)
        true
      end

      def resource_exists?
        true
      end

      def github_adapter
        Citrus::Core::GithubAdapter.new
      end
    end
  end
end
