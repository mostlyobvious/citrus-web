module Citrus
  module Web
    class NullSerializer

      def dump(object)
        object
      end

      def load(object)
        object
      end

    end
  end
end
