require 'spec_helper'

describe Citrus::Web::PublishEvents do

  let(:publish_events) { described_class.new(pubsub_adapter) }
  let(:pubsub_adapter) { fake(:publisher) { Citrus::Web::ZmqPubsubAdapter::Publisher } }
  let(:event)          { 'dummy' }
  let(:subject)        { 'events.*' }

  context '#call' do
    before  { publish_events.(subject, event) }
    specify { expect(pubsub_adapter).to have_received.publish(subject, event) }
  end

end
