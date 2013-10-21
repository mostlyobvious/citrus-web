require 'spec_helper'

describe Citrus::Web::BuildConsoleResource do
  ENOUGH_TIME_FOR_FIBER_ENCODER_TO_BLOCK = 0.125

  let(:builds_repository) { fake(:builds_repository) }
  let(:build)             { fake(:build, output: output) { Citrus::Core::Build } }
  let(:output)            { fake(:file_output, path: file.path) }
  let(:file)              { Tempfile.new('file_output') }

  before do
    stub(injector).builds_repository { builds_repository }
    stub(injector).configuration     { configuration }
    stub(configuration).streamer_url { streamer_url  }
  end

  context 'GET /builds/:build_id/console' do
    context 'successfull' do
      before  { stub(builds_repository).find_by_uuid('1') { build } }
      subject { get '/builds/1/console' }

      specify { expect(subject.code).to                 eq(301) }
      specify { expect(subject.headers['Location']).to  eq(streamer_url) }
    end

    context 'build does not exist' do
      before  { stub(builds_repository).find_by_uuid('2') { raise Citrus::Web::BuildsRepository::NotFound } }
      subject { get '/builds/2/console' }

      specify { expect(subject.code).to                     eq(404) }
      specify { expect(subject.headers['Content-Type']).to  eq('text/html') }
    end
  end

end
