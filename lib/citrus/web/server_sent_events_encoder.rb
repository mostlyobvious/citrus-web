module Citrus
  module Web
    class ServerSentEventsEncoder

      def call(payload)
        "data: #{payload.strip}\n\n"
      end

    end
  end
end
