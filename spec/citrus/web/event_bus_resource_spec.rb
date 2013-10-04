require 'spec_helper'

describe Citrus::Web::EventBusResource do

  let(:subscribe_events) { fake(:subscribe_events) }

  before { stub(injector).subscribe_events { subscribe_events } }

  context 'GET /events' do
    context 'successfull' do
      subject { get '/events' }

      specify { expect(subject.code).to                     eq(200) }
      specify { expect(subject.headers['Content-Type']).to  eq('text/event-stream') }
      specify { expect(subject.headers['Connection']).to    eq('keep-alive') }
      specify { expect(subject.headers['Cache-Control']).to eq('no-cache') }

      it 'should subscribe to events' do
        mock(subscribe_events).call('event')
        stream_body { |chunk| break }
      end

      it 'should stream published events' do
        pending 'how one does stub blocks?'
        stub(subscribe_events).call('event')
        chunk = stream_body { |chunk| break(chunk) }
        expect(chunk).to eq("d\r\ndata: event\n\n\r\n")
      end
    end
  end

end
