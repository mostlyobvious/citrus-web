module Citrus
  module Web
    class GithubPushResource < Webmachine::Resource
      def allowed_methods
        %w(POST)
      end

      def process_post
        github_adapter.create_changeset_from_push_data(request.body.to_s)
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
