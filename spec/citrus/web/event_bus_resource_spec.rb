require 'spec_helper'

describe Citrus::Web::EventBusResource do

  let(:subscribe_events) { fake(:subscribe_events) }

  before do
    stub(injector).subscribe_events { subscribe_events }
  end

  context 'GET /events' do
    subject { get '/events' }

    specify { expect(subject.code).to                             eq(200) }
    specify { expect(subject.headers['Content-Type']).to          eq('text/event-stream') }
    specify { expect(subject.headers['Connection']).to            eq('keep-alive') }
    specify { expect(subject.headers['Cache-Control']).to         eq('no-cache') }
    specify { expect(subject.headers['Transfer-Encoding']).to_not eq('chunked') }
    specify { expect(subject.headers['Content-Length']).to        be_nil }

    it 'should subscribe client for streaming handled by other party' do
      get '/events', headers: {'X-Mongrel2-Connection-Id' => 'abc'}
      expect(subscribe_events).to have_received.call('abc')
    end
  end

end
