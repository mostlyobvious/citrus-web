require 'spec_helper'

describe Citrus::Web::EventSubscriber do

  let(:event_subscriber) { described_class.new(publish_events, clock) }
  let(:publish_events)   { fake(:publish_events) }
  let(:clock)            { fake(:clock) }
  let(:build)            { fake(:build)  { Citrus::Core::Build } }
  let(:result)           { fake(:result) { Citrus::Core::ExitCode } }
  let(:event)            { fake(:event) }
  let(:time)             { Time.new }
  let(:error)            { Exception.new }
  let(:subject)          { 'events' }

  specify { expect(event_subscriber).to respond_to(:build_succeeded) }
  specify { expect(event_subscriber).to respond_to(:build_failed) }
  specify { expect(event_subscriber).to respond_to(:build_aborted) }
  specify { expect(event_subscriber).to respond_to(:build_started) }


  context 'callbacks' do
    before do
      stub(Citrus::Web::Event).new(any_args) { event }
      stub(clock).now { time }
    end

    context '#build_succeeded' do
      before  { event_subscriber.build_succeeded(build, result) }
      specify { expect(publish_events).to     have_received.call(subject, event) }
      specify { expect(Citrus::Web::Event).to have_received.new(:build_succeeded, time, build) }
    end

    context '#build_failed' do
      before  { event_subscriber.build_failed(build, result) }
      specify { expect(publish_events).to     have_received.call(subject, event) }
      specify { expect(Citrus::Web::Event).to have_received.new(:build_failed, time, build) }
    end

    context '#build_aborted' do
      before  { event_subscriber.build_aborted(build, error) }
      specify { expect(publish_events).to     have_received.call(subject, event) }
      specify { expect(Citrus::Web::Event).to have_received.new(:build_aborted, time, build) }
    end

    context '#build_started' do
      before  { event_subscriber.build_started(build) }
      specify { expect(publish_events).to     have_received.call(subject, event) }
      specify { expect(Citrus::Web::Event).to have_received.new(:build_started, time, build) }
    end

  end

end
