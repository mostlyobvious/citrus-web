require 'spec_helper'

describe Citrus::Web::GithubPushResource do

  let(:push_data)      { File.read(File.expand_path(File.join(File.dirname(__FILE__), '../../payload.json'))) }
  let(:github_payload) { URI.encode_www_form(payload: push_data) }
  let(:github_adapter) { fake(:github_adapter) { Citrus::Core::GithubAdapter } }
  let(:changeset)      { fake(:changeset)      { Citrus::Core::Changeset } }
  let(:create_build)   { fake(:create_build) }

  before do
    stub(injector).create_build                                    { create_build }
    stub(injector).github_adapter                                  { github_adapter }
    stub(github_adapter).create_changeset_from_push_data(any_args) { changeset }
  end

  context 'POST /github_push' do
    before  { post '/github_push', body: github_payload }

    specify { expect(response.code).to  eq(204) }
    specify { expect(response.body).to  be_nil }
    specify { expect(github_adapter).to have_received.create_changeset_from_push_data(push_data) }
    specify { expect(create_build).to   have_received.call(changeset) }
  end

end
