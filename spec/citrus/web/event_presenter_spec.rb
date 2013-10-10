require 'spec_helper'

describe Citrus::Web::EventPresenter do

  let(:event_presenter) { described_class.new }
  let(:event)           { Citrus::Web::Event.new(kind, timestamp, build) }
  let(:timestamp)       { Time.at(0).utc }
  let(:kind)            { :build_started }
  let(:build)           { Citrus::Core::Build.new(changeset, uuid, nil) }
  let(:uuid)            { SecureRandom.uuid }
  let(:changeset)       { Citrus::Core::GithubAdapter.new.create_changeset_from_push_data(push_data) }
  let(:push_data)       { Pathname.new(File.dirname(__FILE__)).join('../../fixtures/github_push_data.json').read }

  context '#call' do
    subject { event_presenter.(event) }

    specify { expect(subject).to include('timestamp' => '1970-01-01T00:00:00Z') }
    specify { expect(subject).to include('kind'      => 'build_started')        }
    specify { expect(subject).to have_key('build') }

    specify { expect(subject['build']).to include('uuid' => uuid) }
    specify { expect(subject['build']).to have_key('changeset') }

    specify { expect(subject['build']['changeset']).to include('repository_url' => 'https://github.com/octokitty/testing') }
    specify { expect(subject['build']['changeset']).to have_key('commits') }

    specify { expect(subject['build']['changeset']['commits']).to have(3).items }
    specify { expect(subject['build']['changeset']['commits'].first).to include('sha'     => 'c441029cf673f84c8b7db52d0a5944ee5c52ff89') }
    specify { expect(subject['build']['changeset']['commits'].first).to include('message' => 'Test') }
    specify { expect(subject['build']['changeset']['commits'].first).to include('author'  => 'Garen Torikian') }
  end

end
