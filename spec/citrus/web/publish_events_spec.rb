require 'spec_helper'

describe Citrus::Web::PublishEvents do

  let(:publish_events)  { described_class.new(pubsub_adapter, presenter) }
  let(:pubsub_adapter)  { fake(:publisher) { Citrus::Web::ZmqPubsubAdapter::Publisher } }
  let(:presenter)       { fake(:event_presenter) }
  let(:presented_event) { fake }
  let(:event)           { 'dummy' }
  let(:subject)         { 'events.*' }

  context '#call' do
    before do
      stub(presenter).call(event) { presented_event }
      publish_events.(subject, event)
    end

    specify { expect(presenter).to      have_received.call(event) }
    specify { expect(pubsub_adapter).to have_received.publish(subject, presented_event) }
  end

end
