$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__), 'lib'))
require 'citrus/web/application'

application = Citrus::Web::Application.new
run application.adapter
