require 'spec_helper'

describe Citrus::Web::BuildConsoleSubscriber do

  let(:build_console_subscriber) { described_class.new(publish_console) }
  let(:publish_console)          { fake(:publish_console) }
  let(:build)                    { fake(:build, uuid: 'build_123') { Citrus::Core::Build } }

  specify { expect(build_console_subscriber).to respond_to(:build_output_received) }

  context 'callbacks' do
    context '#build_output_received' do
      before  { build_console_subscriber.build_output_received(build, 'dummy') }

      specify { expect(publish_console).to have_received.call('build_123', 'dummy') }
    end
  end
end
