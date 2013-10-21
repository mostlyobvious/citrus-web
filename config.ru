$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__), 'lib'))
require 'citrus/web'

citrus_root   = ENV['CITRUS_ROOT']         || '/tmp/citrus'
streamer_url  = ENV['CITRUS_STREAMER_URL'] || 'http://127.0.0.1:9090'
configuration = Citrus::Web::Configuration.new(citrus_root, streamer_url)
application   = Citrus::Web::Application.new(configuration)
application.start
run application.rack_application
