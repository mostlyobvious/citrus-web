module Citrus
  module Web
    class CreateBuild

      takes :builds_repository, :build_queue

      def call(changeset)
        build  = builds_repository.create_build(changeset, Core::TestOutput.new)
        build_queue.push(build)
      end

    end
  end
end
