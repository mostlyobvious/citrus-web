require 'm2r'
require 'm2r/version'
require 'uri'
require 'webmachine/version'
require 'webmachine/headers'
require 'webmachine/request'
require 'webmachine/response'
require 'webmachine/dispatcher'

module Webmachine
  module Adapters
    class M2R < Adapter

      def run
        adapter_options = {
          :sender_id => '8699e94e-ee48-4274-9461-5907fa0efc4a',
          :recv_addr => 'tcp://127.0.0.1:1234',
          :send_addr => 'tcp://127.0.0.1:4321'
        }.merge(configuration.adapter_options)

        @handler = Handler.new(@dispatcher, adapter_options)
        trap('INT', &method(:shutdown))
        @handler.listen
      end

      def shutdown
        @handler.stop
      end

      class Handler < ::M2R::Handler

        attr_reader :dispatcher

        def initialize(dispatcher, options)
          super(::M2R::ConnectionFactory.new(OpenStruct.new(options)), ::M2R::Parser.new)
          @dispatcher = dispatcher
        end

        def process(m2r_request)
          method = m2r_request.method
          body   = m2r_request.body
          uri    = request_uri(m2r_request.path, m2r_request.headers)

          headers  = Webmachine::Headers.new(m2r_request.headers.dup)
          request  = Webmachine::Request.new(method, uri, headers, body)
          response = Webmachine::Response.new
          dispatcher.dispatch(request, response)

          response.headers['Server'] = [Webmachine::SERVER_STRING, "M2R/#{::M2R::VERSION}"].join(" ")
          puts response.inspect

          ::M2R::Reply.new.to(m2r_request)
                      .status(response.code)
                      .headers(response.headers)
                      .body(response.body)
        end

        def on_error(request, response, error)
          raise error
        end

        protected

        def request_uri(path, headers)
          host_parts = headers['Host'].split(':')
          path_parts = path.split('?')
          uri_hash   = {
            host: host_parts.first,
            path: path_parts.first
          }
          uri_hash[:port]  = host_parts.last.to_i if host_parts.length == 2
          uri_hash[:query] = path_parts.last      if path_parts.length == 2

          URI::HTTP.build(uri_hash)
        end

      end
    end
  end
end
