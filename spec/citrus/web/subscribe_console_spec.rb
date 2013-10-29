require 'spec_helper'

describe Citrus::Web::SubscribeConsole do

  let(:subscribe_console) { described_class.new(pubsub_adapter) }
  let(:pubsub_adapter)    { fake(:publisher) { Citrus::Web::ZmqPubsubAdapter::Publisher } }
  let(:client_id)         { 'client_id' }
  let(:build_id)          { 'build_id' }

  context '#call' do
    before  { subscribe_console.(build_id, client_id) }
    specify { expect(pubsub_adapter).to have_received.publish('subscribe_console', 'build_id client_id') }
  end

end
