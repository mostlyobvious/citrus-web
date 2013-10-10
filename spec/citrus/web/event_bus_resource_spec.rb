require 'spec_helper'

describe Citrus::Web::EventBusResource do

  let(:subscribe_events) { fake(:subscribe_events) }
  let(:event_presenter)  { fake(:event_presenter) }
  let(:event)            { fake(:event) }

  before do
    stub(injector).subscribe_events { subscribe_events }
    stub(injector).event_presenter  { event_presenter  }
  end

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
        pending 'waiting on https://github.com/psyho/bogus/issues/44'

        stub(subscribe_events).call('event') # yield event
        chunk = stream_body { |chunk| break(chunk) }
        expect(chunk).to eq("d\r\ndata: #{JSON.dump(event)}\n\n\r\n")
      end

      it 'should format events using presenter' do
        pending 'waiting on https://github.com/psyho/bogus/issues/44'

        stub(subscribe_events).call('event') # yield event
        mock(event_presenter).call(event)
        stream_body { |chunk| break }
      end
    end
  end

end
