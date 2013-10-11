module Citrus
  module Web
    class Clock

      def now
        Time.now.utc
      end

    end
  end
end
