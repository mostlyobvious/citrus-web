require 'spec_helper'

describe Citrus::Web::BuildsRepository do
  UUID_REGEX = /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/

  let(:builds_repository) { described_class.new }
  let(:changeset)         { fake(:changeset)   { Citrus::Core::Changeset  } }
  let(:output)            { fake(:test_output) { Citrus::Core::TestOutput } }

  context '#create_build' do
    let(:build) { builds_repository.create_build(changeset, output) }

    specify { expect(build).to      be_kind_of(Citrus::Core::Build) }
    specify { expect(build.uuid).to match UUID_REGEX }
  end

  context '#find_by_uuid' do
    let(:build) { builds_repository.create_build(changeset, output) }

    specify { expect(builds_repository.find_by_uuid(build.uuid)).to eq(build) }
  end

end
