require 'forwardable'

module Citrus
  module Web
    class FileOutput < Core::TestOutput
      extend Forwardable

      takes :file
      def_delegators :file, :path

      def read
        File.read(path)
      end

      def write(data)
        File.open(path, 'a') { |file| file.write(data) }
      end

    end
  end
end
