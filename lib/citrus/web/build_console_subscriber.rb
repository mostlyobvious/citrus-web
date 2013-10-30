module Citrus
  module Web
    class BuildConsoleSubscriber

      takes :publish_console

      def build_output_received(build, output)
        publish_console.(build.uuid, output)
      end

    end
  end
end
