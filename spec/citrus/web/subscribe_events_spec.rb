require 'spec_helper'

describe Citrus::Web::SubscribeEvents do

  let(:subscribe_events)  { described_class.new(pubsub_adapter) }
  let(:pubsub_adapter)    { fake(:publisher) { Citrus::Web::ZmqPubsubAdapter::Publisher } }
  let(:client_id)         { 'client_id' }

  context '#call' do
    before  { subscribe_events.(client_id) }
    specify { expect(pubsub_adapter).to have_received.publish('subscribe_events', 'client_id') }
  end

end
