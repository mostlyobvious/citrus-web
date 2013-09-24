module Citrus
  module Web
    class GithubPushResource < Resource

      inject :github_adapter, :create_build

      def allowed_methods
        %w(POST)
      end

      def process_post
        _, data   = URI.decode_www_form(request.body.to_s).first
        changeset = github_adapter.create_changeset_from_push_data(data)
        create_build.(changeset)
        true
      end

      def resource_exists?
        true
      end

    end
  end
end
