require 'spec_helper'

describe Citrus::Web::PublishConsole do

  let(:publish_console) { described_class.new(pubsub_adapter) }
  let(:pubsub_adapter)  { fake(:publisher) { Citrus::Web::ZmqPubsubAdapter::Publisher } }
  let(:build_id)        { 'build_123' }

  context '#call' do
    before  { publish_console.(build_id, 'echo 123') }

    specify { expect(pubsub_adapter).to have_received.publish(build_id, 'echo 123') }
  end

end
