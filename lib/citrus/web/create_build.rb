module Citrus
  module Web
    class CreateBuild

      takes :builds_repository, :build_queue

      def call(changeset)
        output = FileOutput.new(Tempfile.new('build-output'))
        build  = builds_repository.create_build(changeset, output)
        build_queue.push(build)
      end

    end
  end
end
