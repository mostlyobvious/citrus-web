module Citrus
  module Web
    class GithubPushResource < Resource

      def allowed_methods
        %w(POST)
      end

      def process_post
        _, data = URI.decode_www_form(request.body.to_s).first
        queue.push(create_build_service.create_from_github_push(data))
        true
      end

      def resource_exists?
        true
      end

      def create_build_service
        Citrus::Core::CreateBuildService.new
      end

    end
  end
end
