require 'm2r'
require 'm2r/version'
require 'ostruct'
require 'uri'
require 'webmachine/chunked_body'

module Webmachine
  module Adapters
    class M2R < Adapter

      def run
        connection = ::M2R::ConnectionFactory.new(OpenStruct.new(adapter_options)).connection
        @handler = Handler.new(connection, @dispatcher)
        %w(INT TERM).map { |signal| trap(signal) { shutdown } }
        @handler.listen
      end

      def shutdown
        @handler.stop
      end

      protected

      def adapter_defaults
        {
          :sender_id => '8699e94e-ee48-4274-9461-5907fa0efc4a',
          :recv_addr => 'tcp://127.0.0.1:1234',
          :send_addr => 'tcp://127.0.0.1:4321'
        }
      end

      def adapter_options
        adapter_defaults.merge(configuration.adapter_options)
      end

      class Handler

        attr_reader :wm_dispatcher, :adapter_options, :request_parser, :poller, :connection

        def initialize(connection, wm_dispatcher, request_parser = ::M2R::Parser.new, poller = ZMQ::Poller.new)
          @request_parser  = request_parser
          @wm_dispatcher   = wm_dispatcher
          @connection      = connection
          @poller          = poller
        end

        def listen
          poller.register_readable(connection.send(:request_socket))
          loop do
            break if stop?
            poller.poll(100)
            process(request_parser.parse(connection.receive)) if poller.readables.include?(connection.send(:request_socket))
          end
          poller.deregister_readable(connection.send(:request_socket))
          connection.send(:response_socket).close
          connection.send(:request_socket).close
        end

        def stop
          @stop = true
        end

        protected

        def stop?
          @stop
        end

        def process(m2r_request)
          wm_request   = convert_request(m2r_request)
          wm_response  = Webmachine::Response.new
          wm_dispatcher.dispatch(wm_request, wm_response)
          m2r_response = convert_response(wm_response)

          return stream(m2r_request, m2r_response) if streamable_response(m2r_response)
          reply(m2r_request, m2r_response)
        end

        def convert_request(m2r_request)
          method  = m2r_request.method
          body    = RequestBody.new(m2r_request)
          uri     = request_uri(m2r_request.path, m2r_request.headers)
          headers = Webmachine::Headers[m2r_request.headers.map { |k, v| [k, v] }]
          headers['X-Mongrel2-Connection-Id'] = m2r_request.conn_id
          Webmachine::Request.new(method, uri, headers, body)
        end

        def convert_response(wm_response)
          wm_response.headers['Server'] = "#{Webmachine::SERVER_STRING} M2R/#{::M2R::VERSION}"
          wm_response.headers.each { |key, value| wm_response.headers[key] = value.join(', ') if value.is_a?(Array) }

          m2r_response = ::M2R::Response.new.status(wm_response.code)
                                            .headers(wm_response.headers)
                                            .body(convert_body(wm_response))
          m2r_response.extend(::M2R::Response::ContentLength) if wm_response.code == 404 # XXX: webmachine bug
          m2r_response
        end

        def streamable_response(m2r_response)
          m2r_response.body.respond_to?(:each)
        end

        def convert_body(wm_response)
          body = wm_response.body
          return ChunkedBody.new(Array(body.call)) if body.respond_to?(:call)
          return ChunkedBody.new(body)             if body.respond_to?(:each) && wm_response.headers['Transfer-Encoding'] == 'chunked'
          body
        end

        def reply(m2r_request, m2r_response)
          respond(m2r_request, m2r_response)
        end

        def stream(m2r_request, m2r_response)
          enumerable_body = m2r_response.body
          respond(m2r_request, m2r_response.body(nil))
          enumerable_body.each { |part| respond(m2r_request, part) }
        end

        def respond(m2r_request, data)
          connection.deliver(m2r_request.sender, m2r_request.conn_id, data)
        end

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

      class RequestBody

        def initialize(request)
          @request = request
        end

        def to_s
          @request.body
        end

        def each
          yield @request.body
        end

      end
    end
  end
end
