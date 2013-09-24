$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__), 'lib'))
require 'citrus/web/application'

configuration = Citrus::Web::Configuration.new
configuration.root = '/tmp/citrus'

application   = Citrus::Web::Application.new(configuration)
application.start
run application.rack_application
