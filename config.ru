$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__), 'lib'))
require 'citrus/web'

citrus_root   = ENV['CITRUS_ROOT'] || '/tmp/citrus'
configuration = Citrus::Web::Configuration.new(citrus_root)
application   = Citrus::Web::Application.new(configuration)
application.start
run application.rack_application
