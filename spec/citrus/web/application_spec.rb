require 'spec_helper'

describe Citrus::Web::Application do

  let(:application)    { described_class.new(configuration) }
  let(:configuration)  { fake(:configuration) }
  let(:build_executor) { fake(:build_executor) { Citrus::Web::ThreadedBuildExecutor } }
  let(:webmachine)     { fake(:webmachine)     { Webmachine::Application } }

  specify { expect(application.webmachine).to be_kind_of(Webmachine::Application) }

  context '#start' do
    before do
      stub(application).build_executor { build_executor }
      stub(application).webmachine     { webmachine }
      application.start
    end

    specify { expect(build_executor).to have_received.start }
    specify { expect(webmachine).to     have_received.run }
  end

end
