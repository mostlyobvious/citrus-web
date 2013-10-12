require 'citrus/web'
require 'support/test_application'

RSpec.configure do |config|
  config.include Citrus::Web::TestApplication
  config.order = 'random'
end

require 'bogus/rspec'
Bogus.configure do |config|
  config.search_modules << Citrus::Web
end

if ENV['CI']
  require 'coveralls'
  Coveralls.wear!
end


