require 'spec_helper'

describe Citrus::Web::EventBusResource do

  let(:subscribe_client)     { fake(:subscribe_client) }
  let(:subscription_subject) { 'events' }
  let(:client_id)            { '1337' }

  before do
    stub(injector).subscribe_client { subscribe_client }
  end

  context 'GET /events' do
    subject { get '/events' }

    specify { expect(subject.code).to                             eq(200) }
    specify { expect(subject.headers['Content-Type']).to          eq('text/event-stream') }
    specify { expect(subject.headers['Connection']).to            eq('keep-alive') }
    specify { expect(subject.headers['Cache-Control']).to         eq('no-cache') }
    specify { expect(subject.headers['Transfer-Encoding']).to_not eq('chunked') }
    specify { expect(subject.headers).to_not                      have_key('Content-Length') }

    it 'should subscribe client for streaming handled by other party' do
      get '/events', headers: { 'X-Mongrel2-Connection-Id' => client_id }
      expect(subscribe_client).to have_received.call(client_id, subscription_subject)
    end
  end

end
