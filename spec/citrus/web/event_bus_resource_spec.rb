require 'spec_helper'

describe Citrus::Web::EventBusResource do

  let(:streamer_url) { 'http://stream.citrus-ci.dev' }

  before do
    stub(injector).configuration     { configuration }
    stub(configuration).streamer_url { streamer_url  }
  end

  context 'GET /events' do
    subject { get '/events' }

    specify { expect(subject.code).to                 eq(301) }
    specify { expect(subject.headers['Location']).to  eq(streamer_url) }
  end

end
