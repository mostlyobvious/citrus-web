require 'spec_helper'

describe Citrus::Web::BuildPresenter do

  let(:build_presenter) { described_class.new }
  let(:build)           { Citrus::Core::Build.new(changeset, uuid, nil) }
  let(:uuid)            { SecureRandom.uuid }
  let(:changeset)       { Citrus::Core::GithubAdapter.new.create_changeset_from_push_data(push_data) }
  let(:push_data)       { Pathname.new(File.dirname(__FILE__)).join('../../fixtures/github_push_data.json').read }

  context '#call' do
    subject { build_presenter.(build) }

    specify { expect(subject).to include('uuid' => uuid) }
    specify { expect(subject).to have_key('changeset') }

    specify { expect(subject['changeset']).to include('repository_url' => 'https://github.com/octokitty/testing') }
    specify { expect(subject['changeset']).to have_key('commits') }

    specify { expect(subject['changeset']['commits']).to have(3).items }
    specify { expect(subject['changeset']['commits'].first).to include('sha'     => 'c441029cf673f84c8b7db52d0a5944ee5c52ff89') }
    specify { expect(subject['changeset']['commits'].first).to include('message' => 'Test') }
    specify { expect(subject['changeset']['commits'].first).to include('author'  => 'Garen Torikian') }

  end

end
