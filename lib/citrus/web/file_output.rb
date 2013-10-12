require 'forwardable'

module Citrus
  module Web
    class FileOutput < Core::TestOutput
      extend Forwardable

      attr_reader :path

      def initialize(file)
        @path = file.path
      end

      def read
        File.read(path)
      end

      def write(data)
        File.open(path, 'a') { |file| file.write(data) }
      end

    end
  end
end
