require 'spec_helper'

describe Citrus::Web::GithubPushResource do

  let(:app)       { Citrus::Web::Application.new.webmachine }
  let(:push_data) { File.read(File.expand_path(File.join(File.dirname(__FILE__), 'payload.json'))) }
  let(:payload)   { URI.encode_www_form(payload: push_data) }

  it 'should accept POST request with github push data in application/json' do
    post '/github_push', body: payload
    expect(response.code).to eq(204)
  end

end
