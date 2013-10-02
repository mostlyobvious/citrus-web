require 'spec_helper'

describe Citrus::Web::SubscribeEvents do

  let(:subscribe_events) { described_class.new(pubsub_adapter) }
  let(:pubsub_adapter)   { fake(:subscriber) { Citrus::Web::NanoPubsubAdapter::Subscriber } }
  let(:subject)          { 'events.*' }
  let(:subscribe_proc)   { ->(){} }

  context '#call' do
    before  { subscribe_events.(subject, &subscribe_proc) }
    specify { expect(pubsub_adapter).to have_received.subscribe(subject, &subscribe_proc) }
  end

end
