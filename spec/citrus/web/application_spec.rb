require 'spec_helper'

describe Citrus::Web::Application do

  let(:application)    { described_class.new(configuration) }
  let(:configuration)  { fake(:configuration) }
  let(:build_executor) { fake(:build_executor) { Citrus::Web::ThreadedBuildExecutor } }

  specify { expect(application.webmachine).to       be_kind_of(Webmachine::Application) }
  specify { expect(application.rack_application).to respond_to(:call) }

  context '#start' do
    before do
      stub(application).build_executor { build_executor }
      application.start
    end

    specify { expect(build_executor).to have_received.start }
  end

end
