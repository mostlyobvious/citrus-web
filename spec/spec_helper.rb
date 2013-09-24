require 'citrus/web'
require 'webmachine/test'

RSpec.configure do |config|
  config.include Webmachine::Test
  config.order = 'random'
end

require 'bogus/rspec'
Bogus.configure do |config|
  config.search_modules << Citrus::Web
end


