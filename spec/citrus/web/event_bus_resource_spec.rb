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
        subject
        stub(subscribe_events).call(any_args)
        expect(subscribe_events).to have_received.call('event')
      end
    end
  end

end
