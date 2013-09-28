require 'spec_helper'

describe Citrus::Web::CreateBuild do

  let(:create_build)      { described_class.new(builds_repository, build_queue) }
  let(:build_queue)       { fake(:queue) }
  let(:builds_repository) { fake(:builds_repository) }
  let(:output)            { fake(:file_output) }
  let(:changeset)         { fake(:changeset) { Citrus::Core::Changeset } }
  let(:build)             { fake(:build)     { Citrus::Core::Build     } }

  context '#call' do
    before do
      stub(builds_repository).create_build(any_args) { build  }
      stub(Citrus::Web::FileOutput).new(any_args)    { output }
      create_build.(changeset)
    end

    specify { expect(build_queue).to       have_received.push(build) }
    specify { expect(builds_repository).to have_received.create_build(changeset, output) }
  end

end
