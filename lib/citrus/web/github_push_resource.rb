module Citrus
  module Web
    class GithubPushResource < Resource

      inject :github_adapter, :build_queue

      def allowed_methods
        %w(POST)
      end

      def process_post
        _, data = URI.decode_www_form(request.body.to_s).first
        changeset = github_adapter.create_changeset_from_push_data(data)
        build = Core::Build.new(changeset)
        build_queue.push(build)
        true
      end

      def resource_exists?
        true
      end

    end
  end
end
