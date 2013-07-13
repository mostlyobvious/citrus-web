require 'spec_helper'

describe Citrus::Web::BuildConsoleResource do

  let(:app) { Citrus::Web::Application.new.webmachine }

  before  { get '/builds/dummy/console' }

  specify { expect(response.code).to eq(200) }
  specify { expect(response.headers['Content-Type']).to eq('text/event-stream') }

end
